---@class vim.lsp.Client
---@field is_done boolean
---@field spinner_idx integer
---@field winid? integer
---@field bufnr? integer
---@field message? string
---@field pos integer
---@field timer? uv.uv_timer_t

---@type table<integer, vim.lsp.Client>
local progress_clients = {}
local total_wins = 0

---@param callback fun()
local function guard(callback)
    local whitelist = {
        "E11: Invalid in command%-line window",
        "E523: Not allowed here",
        "E565: Not allowed to change",
    }
    local ok, err = pcall(callback)

    if ok then
        return true
    end

    if type(err) ~= "string" then
        error(err)
    end

    for _, msg in ipairs(whitelist) do
        if string.find(err, msg) then
            return false
        end
    end

    error(err)
end

---@param client vim.lsp.Client
local function update_win_config(client)
    vim.api.nvim_win_set_config(client.winid, {
        relative = "editor",
        width = #client.message,
        height = 1,
        row = vim.o.lines - vim.o.cmdheight - 1 - client.pos * 3,
        col = vim.o.columns - #client.message,
    })
end

---@param client vim.lsp.Client
---@param params lsp.ProgressParams
local function format_message(client, params)
    local ns = vim.api.nvim_create_namespace "pea.lsp_progress"
    vim.api.nvim_buf_clear_namespace(client.bufnr, ns, 0, 1)

    ---@param pattern string
    ---@param hl_group string
    local function set_mark(pattern, hl_group)
        vim.schedule(function()
            local text = vim.api.nvim_buf_get_lines(client.bufnr, 0, 1, false)[1]
            local start_col, end_col = text:find(pattern)

            if start_col and end_col then
                vim.api.nvim_buf_set_extmark(client.bufnr, ns, 0, start_col - 1, {
                    end_col = end_col,
                    hl_group = hl_group,
                })
            end
        end)
    end

    local icons = require "pea.ui.icons"
    local message = ("[%s]"):format(client.name)
    local kind = params.value.kind
    local title = params.value.title

    if title then
        message = ("%s %s:"):format(message, title)
    end

    set_mark("%[.-%]", "Title")
    set_mark(".-:", "NonText")

    if kind == "end" then
        client.is_done = true
        message = (" %s %s Done!"):format(icons.ui.Tick, message)

        set_mark("Done!", "Function")
        set_mark(icons.ui.Tick, "Function")
    else
        client.is_done = false
        local raw_message = params.value.message
        local percentage = params.value.percentage

        if raw_message then
            message = ("%s %s"):format(message, raw_message)
        end

        if percentage then
            message = ("%s (%d%%)"):format(message, percentage)
        end

        local index = client.spinner_idx or 1
        index = index == #icons.ui.Spinner * 4 and 1 or index + 1
        client.spinner_idx = index

        local spinner = icons.ui.Spinner[math.ceil(index / 4)]
        message = (" %s %s"):format(spinner, message)

        set_mark("%d+/%d+", "CursorLine")
        set_mark("%(%d+%%%)", "Constant")
        set_mark(spinner, "Constant")
    end

    return message
end

---@param client vim.lsp.Client
local function show_message(client)
    local winid = client.winid

    if
        not winid
        or not vim.api.nvim_win_is_valid(winid)
        or vim.api.nvim_win_get_tabpage(winid) ~= vim.api.nvim_get_current_tabpage()
    then
        local success = guard(function()
            winid = vim.api.nvim_open_win(client.bufnr, false, {
                relative = "editor",
                width = #client.message,
                height = 1,
                row = vim.o.lines - vim.o.cmdheight - 1 - client.pos * 3,
                col = vim.o.columns - #client.message,
                focusable = false,
                style = "minimal",
                noautocmd = true,
            })
        end)

        if not success then
            return
        end

        client.winid = winid
        total_wins = total_wins + 1
    else
        update_win_config(client)
    end

    guard(function()
        vim.api.nvim_buf_set_lines(client.bufnr, 0, 1, false, { client.message })
    end)
end

---@param client vim.lsp.Client
---@param params lsp.ProgressParams
local function progress(client, params)
    local id = ("%s.%s"):format(client.id, params.token)

    if not progress_clients[id] then
        local client_data = {
            is_done = false,
            spinner_idx = 0,
            winid = nil,
            bufnr = nil,
            message = nil,
            pos = total_wins + 1,
            timer = nil,
        }

        for k, v in pairs(client) do
            client_data[k] = v
        end

        progress_clients[id] = client_data
    end

    local progress_client = progress_clients[id]

    if not progress_client.bufnr then
        progress_client.bufnr = vim.api.nvim_create_buf(false, true)
    end

    if not progress_client.timer then
        progress_client.timer = vim.uv.new_timer()
    end

    progress_client.message = format_message(progress_client, params)

    show_message(progress_client)

    if progress_client.is_done then
        progress_client.timer:start(
            2000,
            100,
            vim.schedule_wrap(function()
                if not progress_client.is_done or progress_client.winid == nil then
                    progress_client.timer:stop()
                    return
                end

                local success = false
                if progress_client.winid and progress_client.bufnr then
                    success = guard(function()
                        if vim.api.nvim_win_is_valid(progress_client.winid) then
                            vim.api.nvim_win_close(progress_client.winid, true)
                        end

                        if vim.api.nvim_buf_is_valid(progress_client.bufnr) then
                            vim.api.nvim_buf_delete(progress_client.bufnr, { force = true })
                        end
                    end)
                end

                if success then
                    progress_client.timer:stop()
                    progress_client.timer:close()
                    total_wins = total_wins - 1

                    for _, c in pairs(progress_clients) do
                        if c.winid and c.pos > progress_client.pos then
                            c.pos = c.pos - 1
                            update_win_config(c)
                        end
                    end

                    progress_clients[id] = nil
                end
            end)
        )
    end
end

return progress
