local M = {}

local sysname = vim.uv.os_uname().sysname

M.is_windows = sysname:find("Windows")

return M
