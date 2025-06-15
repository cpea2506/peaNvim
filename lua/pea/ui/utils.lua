---See: https://github.com/stevearc/dressing.nvim/blob/master/lua/dressing/util.lua
local M = {}

local function calc_float(value, max_value)
    if value then
        local _, p = math.modf(value)

        if p ~= 0 then
            return math.min(max_value, value * max_value)
        end
    end

    return value
end

local function calc_list(value, max_value, aggregator, limit)
    local result = limit

    if type(value) == "table" then
        for _, v in ipairs(value) do
            result = aggregator(result, calc_float(v, max_value))
        end
    else
        result = aggregator(result, calc_float(value, max_value))
    end

    return result
end

local function get_max_width(relative, winid)
    return relative == "editor" and vim.o.columns or vim.api.nvim_win_get_width(winid or 0)
end

local function get_max_height(relative, winid)
    return relative == "editor" and vim.o.lines - vim.o.cmdheight or vim.api.nvim_win_get_height(winid or 0)
end

local function calc_size(desired_size, current_size, size_limit, total_size)
    local result = calc_float(current_size, total_size)
    local min_val = calc_list(size_limit.min_value, total_size, math.max, 1)
    local max_val = calc_list(size_limit.max_value, total_size, math.min, total_size)

    if not result then
        result = calc_float(desired_size, total_size)
    end

    result = math.min(result, max_val)
    result = math.max(result, min_val)

    return math.floor(result)
end

function M.calc_width(relative, desired_size, current_size, size_limit)
    return calc_size(desired_size, current_size, size_limit, get_max_width(relative))
end

function M.calc_height(relative, desired_size, current_size, size_limit)
    return calc_size(desired_size, current_size, size_limit, get_max_height(relative))
end

function M.get_max_strwidth(lines)
    local max = 0

    for _, line in ipairs(lines) do
        max = math.max(max, vim.api.nvim_strwidth(line))
    end

    return max
end

function M.calc_column(relative, width)
    if relative == "cursor" then
        return 0
    else
        return math.floor((get_max_width(relative) - width) / 2)
    end
end

function M.calc_row(relative, height)
    if relative == "cursor" then
        return 0
    else
        return math.floor((get_max_height(relative) - height) / 2)
    end
end

function M.trim_and_pad_title(title)
    title = vim.trim(title):gsub(":$", "")

    return (" %s "):format(title)
end

return M
