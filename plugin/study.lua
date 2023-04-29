local study = require('study')
local cmd = vim.api.nvim_create_user_command

cmd("Study", study.entry, {})
