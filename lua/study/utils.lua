local config = require("study.config")
local M = {}

local function join_paths(...)
    local path = select(1, ...)
    for i = 2, select("#", ...) do
        path = path .. "/" .. select(i, ...)
    end
    return vim.fn.expand(path)
end

local function read_json(path)
    path = vim.fn.expand(path)
    if vim.fn.filereadable(path) == 1 then
        return vim.json.decode(vim.fn.readfile(path)[1])
    end
    return {}
end

local function write_json(object, path)
    local dir = vim.fn.fnamemodify(path, ":h")
    if vim.fn.isdirectory(dir) == 0 then
        vim.fn.mkdir(dir, "p")
    end

    local json = vim.json.encode(object)
    vim.fn.writefile({ json }, vim.fn.expand(path))
    print(path)
end

function M.get_decks()
    return read_json(join_paths(config.dir, "decks.json"))
end

function M.add_deck(name)
    -- Check name is not empty
    if name == "" then
        print("Name cannot be empty")
        return
    end

    -- Check name is valid for file
    if name ~= name:gsub("%p", "") then
        print("Name must only contain alphanumeric characters")
        return
    end

    -- Check there is no deck with that name
    local decks = M.get_decks()
    if decks and decks[name] ~= nil then
        print("Deck with that name already exists")
        return
    end

    decks[name] = { dir = name }
    write_json(decks, join_paths(config.dir, "decks.json"))
end

return M
