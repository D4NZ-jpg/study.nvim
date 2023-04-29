local M = {}

function M.setup(opts)
    for key, value in pairs(opts) do
        M[key] = value
    end

    M.os = vim.loop.os_uname().sysname
    if M.os:match("Windows") then
        M.path_separator = "\\"
    else
        M.path_separator = "/"
    end
end

return M
