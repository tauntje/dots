require('telescope').setup({
  extensions = {
    ['ui-select'] = { require('telescope.themes').get_dropdown() },
  },
})

pcall(require('telescope').load_extension, 'ui-select')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>so', builtin.oldfiles, { desc = '[S]earch [O]ld files' })
vim.keymap.set('n', '<leader>sn', function()
  builtin.find_files({ cwd = vim.fn.stdpath('config'), follow = true })
end, { desc = '[S]earch [N]eovim files' })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
  callback = function(event)
    local buf = event.buf
    vim.keymap.set('n', 'U', builtin.lsp_implementations, {
      buffer = buf,
      desc = 'Go to implementations',
    })
    vim.keymap.set('n', 'gd', builtin.lsp_definitions, {
      buffer = buf,
      desc = 'Go to definitions',
    })
    vim.keymap.set('n', 'gr', builtin.lsp_references, {
      buffer = buf,
      desc = 'Find references',
    })
    vim.keymap.set('n', '<leader>ds', builtin.lsp_document_symbols, {
      buffer = buf,
      desc = 'Document symbols',
    })
    vim.keymap.set('n', '<leader>ws', builtin.lsp_dynamic_workspace_symbols, {
      buffer = buf,
      desc = 'Workspace symbols',
    })
    vim.keymap.set('n', 'gt', builtin.lsp_type_definitions, {
      buffer = buf,
      desc = 'Go to type definition',
    })
  end,
})

local harpoon = require('harpoon')
harpoon:setup({
  settings = {
    save_on_toggle = true,
    sync_on_ui_close = true,
  },
})

vim.keymap.set('n', '<leader>a', function()
  harpoon:list():add()
end, { desc = 'Add file to Harpoon' })
vim.keymap.set('n', '<leader>h', function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = 'Open Harpoon menu' })
vim.keymap.set('n', '<leader>1', function() harpoon:list():select(1) end, { desc = 'Harpoon file 1' })
vim.keymap.set('n', '<leader>2', function() harpoon:list():select(2) end, { desc = 'Harpoon file 2' })
vim.keymap.set('n', '<leader>3', function() harpoon:list():select(3) end, { desc = 'Harpoon file 3' })
vim.keymap.set('n', '<leader>4', function() harpoon:list():select(4) end, { desc = 'Harpoon file 4' })
vim.keymap.set('n', '<C-S-P>', function() harpoon:list():prev() end, { desc = 'Previous Harpoon file' })
vim.keymap.set('n', '<C-S-N>', function() harpoon:list():next() end, { desc = 'Next Harpoon file' })
