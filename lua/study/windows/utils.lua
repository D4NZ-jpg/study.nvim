local utils = require("study.utils")
local api = vim.api
local M = {}

local function set_mappings()
    local mappings = {
        q = "close_window()",
        n = "new_deck()",
        j = "move_cursor(1)",
        k = "move_cursor(-1)",
    }

    for k, v in pairs(mappings) do
        api.nvim_buf_set_keymap(Buf, "n", k, "<cmd>lua require('study.windows.utils')." .. v .. "<cr>",
            { nowait = true, noremap = true, silent = true })
    end
end

local function center(str)
    local w = api.nvim_win_get_width(0)
    local shift = math.floor(w / 2) - math.floor(string.len(str) / 2)
    return string.rep(' ', shift) .. str
end

function M.move_cursor(dir)
    local h = api.nvim_win_get_height(0)

    local deck_count = 0
    for _, _ in pairs(utils.get_decks()) do
        deck_count = deck_count + 1
    end


    local cursor = api.nvim_win_get_cursor(Win)[1]
    cursor = cursor + dir

    cursor = math.min(cursor, math.min(h - 1, deck_count + 3))
    cursor = math.max(3, cursor)

    api.nvim_win_set_cursor(Win, { cursor, 0 })

    Pos = Pos + dir

    Pos = math.min(Pos, deck_count)
    Pos = math.max(1, Pos)

    M.browse_decks(Pos)
end

function M.browse_decks(curr)
    api.nvim_buf_set_option(Buf, "modifiable", true)

    local w, h = api.nvim_win_get_width(0), api.nvim_win_get_height(0)
    local content = { center("Study"), string.rep("-", w) }
    local cursor = api.nvim_win_get_cursor(Win)[1]

    local decks = utils.get_decks()
    local counter = 0
    for k, _ in pairs(decks) do
        if #content + 1 >= h then
            break
        end

        counter = counter + 1
        if counter > curr - cursor + 2 then
            content[#content + 1] = "- " .. k
        end
    end

    for i = #content + 1, h - 1 do
        content[i] = ""
    end
    content[#content + 1] = center("<q> Exit | <n> New deck")

    api.nvim_buf_set_lines(Buf, 0, -1, false, content)

    api.nvim_buf_add_highlight(Buf, -1, "FloatTitle", 0, 0, -1)
    api.nvim_buf_add_highlight(Buf, -1, "FloatBorder", 1, 0, -1)

    api.nvim_buf_set_option(Buf, "modifiable", false)
end

function M.new_deck()
    local name = vim.fn.input("Name: ")
    utils.add_deck(name)
    M.browse_decks(1)
end

function M.close_window()
    api.nvim_win_close(Win, true)
end

function M.open_window()
    Buf = api.nvim_create_buf(false, true)
    api.nvim_buf_set_option(Buf, "bufhidden", "wipe")

    local w, h = api.nvim_get_option("columns"), api.nvim_get_option("lines")
    local win_h, win_w = math.ceil(h * 0.6 - 4), math.ceil(w * 0.5)
    local row, col = math.ceil((h - win_h) / 2), math.ceil((w - win_w) / 2)

    local opts = {
        style = "minimal",
        relative = "editor",
        width = win_w,
        height = win_h,
        row = row,
        col = col,
        border = "rounded",
    }

    Win = api.nvim_open_win(Buf, true, opts)
    set_mappings()

    Pos = 1
    M.browse_decks(1)
    api.nvim_win_set_cursor(Win, { 3, 0 })
end

return M
