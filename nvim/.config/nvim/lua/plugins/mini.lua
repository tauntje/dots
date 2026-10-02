require('mini.pairs').setup()
require('mini.diff').setup()
require('mini.files').setup()

vim.keymap.set('n', '<C-e>', function()
  local MiniFiles = require('mini.files')
  MiniFiles.open(MiniFiles.get_latest_path())
end, { desc = 'Open file browser' })
