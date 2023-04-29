local config = require("study.config")

local M = {}

function M.entry()

end

function M.setup(opts)
    config.setup(opts or {})
end

return M
