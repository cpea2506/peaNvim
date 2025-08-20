---@class vim.lsp.Client
---@field progress_id string
---@field is_done boolean
---@field spinner_idx integer
---@field winid? integer
---@field bufnr? integer
---@field message? string
---@field pos integer
---@field timer? uv.uv_timer_t

---@type table<string, vim.lsp.Client>
local clients = {}
local total = 0

local api = vim.api
local o = vim.o
local uv = vim.uv

local icons = require "pea.ui.icons"
local ns = api.nvim_create_namespace "pea.lsp_progress"

---@param callback fun()
local function guard(callback)
    local ok, err = pcall(callback)

    if ok then
        return true
    end

    if type(err) ~= "string" then
        error(err)
    end

    for _, m in ipairs {
        "E11: Invalid in command%-line window",
        "E523: Not allowed here",
        "E565: Not allowed to change",
    } do
        if err:find(m) then
            return false
        end
    end

    error(err)
end

---@param client vim.lsp.Client
local function get_win_config(client)
    return {
        relative = "editor",
        width = #client.message,
        height = 1,
        row = o.lines - o.cmdheight - 1 - client.pos * 3,
        col = o.columns - #client.message,
        focusable = false,
        style = "minimal",
    }
end

---@param client vim.lsp.Client
local function update_win_config(client)
    if client.winid and api.nvim_win_is_valid(client.winid) then
        api.nvim_win_set_config(client.winid, get_win_config(client))
    end
end

---@param bufnr integer
---@param pattern string
---@param hl_group string
local function set_mark(bufnr, pattern, hl_group)
    vim.schedule(function()
        local lines = api.nvim_buf_get_lines(bufnr, 0, 1, false)
        local text = lines[1] or ""
        local start_col, end_col = text:find(pattern)

        if start_col and end_col then
            api.nvim_buf_set_extmark(bufnr, ns, 0, start_col - 1, {
                end_col = end_col,
                hl_group = hl_group,
            })
        end
    end)
end

---@param client vim.lsp.Client
---@param params lsp.ProgressParams
local function build_message(client, params)
    local value = params.value or {}

    api.nvim_buf_clear_namespace(client.bufnr, ns, 0, 1)

    local message = ("[%s]"):format(client.name or "")

    if value.title then
        message = ("%s %s:"):format(message, value.title)
    end

    set_mark(client.bufnr, "%[.-%]", "Title")
    set_mark(client.bufnr, ".-:", "NonText")

    if value.kind == "end" then
        client.is_done = true

        local done_message = (" %s %s Done!"):format(icons.ui.Tick, message)

        set_mark(client.bufnr, "Done!", "Function")
        set_mark(client.bufnr, icons.ui.Tick, "Function")

        return done_message
    end

    client.is_done = false

    if value.message then
        message = ("%s %s"):format(message, value.message)
    end

    if value.percentage then
        message = ("%s (%d%%)"):format(message, value.percentage)
    end

    local idx = (client.spinner_idx or 0) + 1
    local frames = #icons.ui.Spinner * 4

    client.spinner_idx = (idx > frames) and 1 or idx

    local spinner = icons.ui.Spinner[math.ceil(client.spinner_idx / 4)]
    message = (" %s %s"):format(spinner, message)

    set_mark(client.bufnr, "%d+/%d+", "CursorLine")
    set_mark(client.bufnr, "%(%d+%%%)", "Constant")
    set_mark(client.bufnr, spinner, "Constant")

    return message
end

---@param client vim.lsp.Client
local function show_progress(client)
    local has_win = client.winid and api.nvim_win_is_valid(client.winid)
    local in_same_tab = has_win and api.nvim_win_get_tabpage(client.winid) == api.nvim_get_current_tabpage()

    if not has_win or not in_same_tab then
        local ok = guard(function()
            client.winid = api.nvim_open_win(client.bufnr, false, get_win_config(client))
        end)

        if not ok then
            return
        end

        total = total + 1
    else
        update_win_config(client)
    end

    guard(function()
        api.nvim_buf_set_lines(client.bufnr, 0, 1, false, { client.message })
    end)
end

---@param client vim.lsp.Client
local function cleanup(client)
    local ok = guard(function()
        if client.winid and api.nvim_win_is_valid(client.winid) then
            api.nvim_win_close(client.winid, true)
        end

        if client.bufnr and api.nvim_buf_is_valid(client.bufnr) then
            api.nvim_buf_delete(client.bufnr, { force = true })
        end
    end)

    if not ok then
        return
    end

    if client.timer and not client.timer:is_closing() then
        client.timer:stop()
        client.timer:close()
    end

    total = math.max(0, total - 1)

    for _, c in pairs(clients) do
        if c.winid and c.pos > client.pos then
            c.pos = c.pos - 1

            update_win_config(c)
        end
    end

    clients[client.progress_id] = nil
end

---@param client vim.lsp.Client
---@param params lsp.ProgressParams
return function(client, params)
    client.progress_id = ("%s.%s"):format(client.id, params.token)

    local progress_client = clients[client.progress_id]

    if not progress_client then
        local progress_client_data = {
            name = client.name,
            is_done = false,
            spinner_idx = 0,
            pos = total + 1,
        }

        for key, value in pairs(client) do
            progress_client_data[key] = value
        end

        clients[client.progress_id] = progress_client_data

        progress_client = clients[client.progress_id]
    end

    if not progress_client.bufnr then
        progress_client.bufnr = api.nvim_create_buf(false, true)
    end

    if not progress_client.timer then
        progress_client.timer = uv.new_timer()
    end

    progress_client.message = build_message(progress_client, params)

    show_progress(progress_client)

    if progress_client.is_done then
        progress_client.timer:start(
            2000,
            100,
            vim.schedule_wrap(function()
                if not progress_client.is_done or not progress_client.winid then
                    progress_client.timer:stop()

                    return
                end

                cleanup(progress_client)
            end)
        )
    end
end
