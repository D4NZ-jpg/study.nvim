local M = {
    dir = "~/.config/study"
}

function M.setup(opts)
    for key, value in pairs(opts) do
        M[key] = value
    end
end

return M
