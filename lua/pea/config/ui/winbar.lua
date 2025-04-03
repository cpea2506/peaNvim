local icons = require("pea.config.ui.icons")

local config = {
	icons = icons.kind,
	separator = icons.ui.ChevronRight,
	exclude_filetypes = { "help", "lazy", "toggleterm", "noice", "oil", "" },
}

setmetatable(config.icons, {
	__index = function()
		return "?"
	end,
})

local lsp_str_to_num = {
	File = 1,
	Module = 2,
	Namespace = 3,
	Package = 4,
	Class = 5,
	Method = 6,
	Property = 7,
	Field = 8,
	Constructor = 9,
	Enum = 10,
	Interface = 11,
	Function = 12,
	Variable = 13,
	Constant = 14,
	String = 15,
	Number = 16,
	Boolean = 17,
	Array = 18,
	Object = 19,
	Key = 20,
	Null = 21,
	EnumMember = 22,
	Struct = 23,
	Event = 24,
	Operator = 25,
	TypeParameter = 26,
}

setmetatable(lsp_str_to_num, {
	__index = function()
		return 0
	end,
})

local lsp_num_to_str = {}

for k, v in pairs(lsp_str_to_num) do
	lsp_num_to_str[v] = k
end

setmetatable(lsp_num_to_str, {
	__index = function()
		return "Text"
	end,
})

for k, v in pairs(config.icons) do
	if lsp_str_to_num[k] then
		config.icons[lsp_str_to_num[k]] = v
	end
end

local function request_symbol(client, bufnr, handler, retry_count)
	retry_count = retry_count or 5

	if retry_count == 0 then
		handler(bufnr, {})
		return
	end

	if not vim.api.nvim_buf_is_loaded(bufnr) then
		return
	end

	local params = vim.lsp.util.make_text_document_params(bufnr)

	client:request("textDocument/documentSymbol", { textDocument = params }, function(err, symbols)
		if err == nil then
			handler(bufnr, symbols or {})
		else
			if vim.api.nvim_buf_is_valid(bufnr) then
				vim.defer_fn(function()
					request_symbol(client, bufnr, handler, retry_count - 1)
				end, 750)
			end
		end
	end, bufnr)
end

local function get_symbol_relation(symbol, other)
	local s = symbol.scope
	local o = other.scope

	if
		o["end"].line < s["start"].line
		or (o["end"].line == s["start"].line and o["end"].character <= s["start"].character)
	then
		return "before"
	end

	if
		o["start"].line > s["end"].line
		or (o["start"].line == s["end"].line and o["start"].character >= s["end"].character)
	then
		return "after"
	end

	if
		(
			o["start"].line < s["start"].line
			or (o["start"].line == s["start"].line and o["start"].character <= s["start"].character)
		)
		and (
			o["end"].line > s["end"].line
			or (o["end"].line == s["end"].line and o["end"].character >= s["end"].character)
		)
	then
		return "around"
	end

	return "within"
end

local function create_symbol_tree(symbols)
	for _, node in ipairs(symbols) do
		node.scope = node.location.range
		node.scope["start"].line = node.scope["start"].line + 1
		node.scope["end"].line = node.scope["end"].line + 1
		node.location = nil
	end

	table.sort(symbols, function(a, b)
		local relation = get_symbol_relation(a, b)

		if relation == "after" or relation == "within" then
			return true
		end

		return false
	end)

	local tree = {
		scope = {
			start = {
				line = -10,
				character = 0,
			},
			["end"] = {
				line = 2147483640,
				character = 0,
			},
		},
		children = {},
	}

	local stack = {}

	table.insert(tree.children, symbols[1])
	table.insert(stack, tree)

	for i = 2, #symbols, 1 do
		local prev_chain_node_relation = get_symbol_relation(symbols[i], symbols[i - 1])
		local stack_top_node_relation = get_symbol_relation(symbols[i], stack[#stack])

		if prev_chain_node_relation == "around" then
			table.insert(stack, symbols[i - 1])

			if not symbols[i - 1].children then
				symbols[i - 1].children = {}
			end

			table.insert(symbols[i - 1].children, symbols[i])
		elseif prev_chain_node_relation == "before" and stack_top_node_relation == "around" then
			table.insert(stack[#stack].children, symbols[i])
		elseif stack_top_node_relation == "before" then
			while get_symbol_relation(symbols[i], stack[#stack]) ~= "around" do
				stack[#stack] = nil
			end

			table.insert(stack[#stack].children, symbols[i])
		end
	end

	return tree.children
end

local function parse(symbols)
	local parsed_symbols = {}

	local function dfs(curr_symbol)
		local result = {}

		for index, value in ipairs(curr_symbol) do
			local curr_parsed_symbol = {}

			local scope = value.range
			scope["start"].line = scope["start"].line + 1
			scope["end"].line = scope["end"].line + 1

			curr_parsed_symbol = {
				name = value.name or "<???>",
				scope = scope,
				kind = value.kind or 0,
				index = index,
			}

			if value.children then
				curr_parsed_symbol.children = dfs(value.children)
			end

			result[#result + 1] = curr_parsed_symbol
		end

		if result then
			table.sort(result, function(a, b)
				if b.scope.start.line == a.scope.start.line then
					return b.scope.start.character > a.scope.start.character
				end

				return b.scope.start.line > a.scope.start.line
			end)
		end

		return result
	end

	if #symbols >= 1 and symbols[1].range == nil then
		parsed_symbols = create_symbol_tree(symbols)
	else
		parsed_symbols = dfs(symbols)
	end

	return parsed_symbols
end

local awaiting_lsp_response = {}
local curr_symbols = {}
local curr_context_data = {}

local function update_data(bufnr, symbols)
	awaiting_lsp_response[bufnr] = false
	curr_symbols[bufnr] = parse(symbols)
end

local function get_position(line, char, range)
	if line < range["start"].line then
		return -1
	elseif line > range["end"].line then
		return 1
	end

	if line == range["start"].line and char < range["start"].character then
		return -1
	elseif line == range["end"].line and char > range["end"].character then
		return 1
	end

	return 0
end

local function update_context(bufnr)
	if curr_context_data[bufnr] == nil then
		curr_context_data[bufnr] = {}
	end

	local curr_symbol = curr_symbols[bufnr]

	if curr_symbol == nil then
		return
	end

	local old_context_data = curr_context_data[bufnr]
	local new_context_data = {}
	local line, char = unpack(vim.api.nvim_win_get_cursor(0))

	for _, context in ipairs(old_context_data) do
		if curr_symbol == nil then
			break
		end

		if
			get_position(line, char, context.scope) == 0
			and curr_symbol[context.index] ~= nil
			and context.name == curr_symbol[context.index].name
			and context.kind == curr_symbol[context.index].kind
		then
			table.insert(new_context_data, curr_symbol[context.index])
			curr_symbol = curr_symbol[context.index].children
		else
			break
		end
	end

	while curr_symbol ~= nil do
		local go_deeper = false
		local low = 1
		local hight = #curr_symbol

		while low <= hight do
			local mid = bit.rshift(low + hight, 1)
			local pos = get_position(line, char, curr_symbol[mid].scope)

			if pos == -1 then
				hight = mid - 1
			elseif pos == 1 then
				low = mid + 1
			else
				table.insert(new_context_data, curr_symbol[mid])
				curr_symbol = curr_symbol[mid].children
				go_deeper = true

				break
			end
		end

		if not go_deeper then
			break
		end
	end

	curr_context_data[bufnr] = new_context_data
end

local function is_empty(s)
	return s == nil or s == ""
end

local function get_filename()
	local filename = vim.fn.expand("%:t")

	if is_empty(filename) then
		return ""
	end

	local extension = vim.fn.expand("%:e")
	local devicons = require("nvim-web-devicons")
	local fileicon, hlgroup = devicons.get_icon(filename, extension, { default = true })

	return " " .. "%#" .. hlgroup .. "#" .. fileicon .. "%*" .. " " .. "%#WinBar#" .. filename .. "%*"
end

local function get_data(bufnr)
	local context_data = curr_context_data[bufnr]

	if not context_data then
		return nil
	end

	local result = {}

	for _, value in ipairs(context_data) do
		result[#result + 1] = {
			kind = value.kind,
			type = lsp_num_to_str[value.kind],
			name = value.name,
			icon = config.icons[value.kind],
			scope = value.scope,
		}
	end

	return result
end

local function get_locations(bufnr)
	local filename = get_filename()

	if not vim.b[bufnr].winbar_client_id then
		return filename
	end

	local data = get_data(bufnr)

	if data == nil then
		return filename
	end

	local locations = { filename }

	for _, value in ipairs(data) do
		local name = string.gsub(value.name, "%%", "%%%%")
		name = string.gsub(name, "\n", " ")

		locations[#locations + 1] = "%#NavicIcons"
			.. lsp_num_to_str[value.kind]
			.. "#"
			.. config.icons[value.kind]
			.. " %*%#NavicText#"
			.. name
			.. "%*"
	end

	return table.concat(locations, " %#NavicSeparator#" .. config.separator .. "%* ")
end

local augroup = vim.api.nvim_create_augroup("pea_winbar", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)

		if not client:supports_method("textDocument/documentSymbol") then
			return
		end

		local bufnr = args.buf
		local changedtick = 0

		vim.b[bufnr].winbar_client_id = client.id

		vim.api.nvim_create_autocmd({ "InsertLeave", "BufEnter", "CursorHold" }, {
			group = augroup,
			buffer = bufnr,
			callback = function()
				if not awaiting_lsp_response[bufnr] and changedtick < vim.b[bufnr].changedtick then
					awaiting_lsp_response[bufnr] = true
					changedtick = vim.b[bufnr].changedtick

					request_symbol(client, bufnr, update_data)
				end
			end,
		})

		vim.api.nvim_create_autocmd({ "CursorHold", "CursorMoved" }, {
			group = augroup,
			buffer = bufnr,
			callback = function()
				update_context(bufnr)
			end,
		})

		vim.api.nvim_create_autocmd({ "BufDelete" }, {
			group = augroup,
			buffer = bufnr,
			callback = function()
				curr_context_data[bufnr] = nil
				curr_symbols[bufnr] = nil
			end,
		})

		request_symbol(client, bufnr, update_data)
	end,
})

vim.api.nvim_create_autocmd({
	"CursorHoldI",
	"CursorHold",
	"BufWinEnter",
	"BufFilePost",
	"InsertEnter",
	"BufWritePost",
	"TabClosed",
	"TabEnter",
}, {
	group = augroup,
	callback = function(args)
		local bufnr = args.buf

		if vim.tbl_contains(config.exclude_filetypes, vim.bo[bufnr].filetype) then
			return
		end

		local winbar = get_locations(bufnr)

		if vim.bo[bufnr].mod then
			winbar = winbar .. " %#LspCodeLens#" .. icons.ui.Circle .. "%*"
		end

		vim.api.nvim_set_option_value("winbar", winbar, { scope = "local" })
	end,
})
