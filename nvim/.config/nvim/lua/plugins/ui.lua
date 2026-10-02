vim.cmd.colorscheme('catppuccin')

require('no-neck-pain').setup()
require('render-markdown').setup({})

-- Preserve the writing-mode behavior when Neovim starts directly in Markdown.
vim.api.nvim_create_autocmd('VimEnter', {
  group = vim.api.nvim_create_augroup('markdown-writing-mode', { clear = true }),
  desc = 'Enable centered writing for a Markdown startup buffer',
  callback = function()
    if vim.bo.filetype == 'markdown' then
      vim.cmd('NoNeckPain')
    end
  end,
})
