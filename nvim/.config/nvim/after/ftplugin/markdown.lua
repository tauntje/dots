vim.opt_local.spelllang = 'fr'
vim.opt_local.spell = true
vim.opt_local.linebreak = true
vim.opt_local.wrap = true
vim.opt_local.wrapmargin = 10
vim.opt_local.formatoptions:append('t')

vim.keymap.set('n', '<leader>c', '1z=', {
  buffer = true,
  desc = 'Correct spelling under cursor',
})
