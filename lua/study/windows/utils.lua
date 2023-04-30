local api = vim.api
local M = {}

local function set_mappings()
    local mappings = {
        q = "close_window()"
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

    local content = { center("Study"), string.rep("-", win_w) }
    for i = #content + 1, win_h - 1 do
        content[i] = ""
    end
    content[#content + 1] = center("<q> exit")


    api.nvim_buf_set_lines(Buf, 0, -1, false, content)

    api.nvim_buf_add_highlight(Buf, -1, "FloatTitle", 0, 0, -1)
    api.nvim_buf_add_highlight(Buf, -1, "FloatBorder", 1, 0, -1)

    api.nvim_buf_set_option(Buf, "modifiable", false)
end

return M
