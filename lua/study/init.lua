local config = require("study.config")
local windows = require("study.windows.utils")

local M = {}

function M.entry()
    windows.open_window()
end

function M.setup(opts)
    config.setup(opts or {})
end

return M
