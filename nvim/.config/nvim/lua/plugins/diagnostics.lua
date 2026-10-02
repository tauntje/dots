require('trouble').setup({})

vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>', {
  desc = 'Workspace diagnostics',
})
vim.keymap.set('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', {
  desc = 'Buffer diagnostics',
})
vim.keymap.set('n', '<leader>cs', '<cmd>Trouble symbols toggle focus=false<CR>', {
  desc = 'Document symbols',
})
vim.keymap.set('n', '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<CR>', {
  desc = 'LSP references',
})
