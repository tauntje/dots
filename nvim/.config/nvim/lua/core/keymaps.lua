-- Free up keys used by this config.
vim.keymap.set('n', 's', '<Nop>')
vim.keymap.set('n', '<C-b>', '<Nop>')

-- Search
vim.keymap.set('n', '<Esc>', vim.cmd.nohlsearch, { desc = 'Clear search highlighting' })

-- Keep the cursor centered while navigating search results and pages.
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Splits
vim.keymap.set('n', '<leader>v', '<C-w>v', { desc = 'Split window vertically' })
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to lower window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to upper window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

-- Move selected lines and keep the selection active.
vim.keymap.set('v', '<C-j>', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', '<C-k>', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left and reselect' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right and reselect' })

-- Markdown table formatting
vim.keymap.set('v', '<leader>ft', ":! tr -s ' ' | column -t -s '|' -o '|'<CR>", {
  desc = 'Format Markdown table',
})

-- Plugin commands
vim.keymap.set('n', '<leader>np', '<cmd>NoNeckPain<CR>', { desc = 'Toggle centered writing' })

-- Format the current buffer.
vim.keymap.set({ 'n', 'v' }, '<leader>F', function()
  require('conform').format({ async = true, lsp_format = 'fallback' })
end, { desc = 'Format buffer' })
