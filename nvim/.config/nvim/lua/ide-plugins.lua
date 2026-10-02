vim.pack.add({
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
    { src = 'https://github.com/folke/trouble.nvim' },
})

local treesitter_languages = {
    'angular',
    'bash',
    'css',
    'html',
    'javascript',
    'json',
    'lua',
    'markdown',
    'markdown_inline',
    'scss',
    'tsx',
    'typescript',
    'vim',
    'vimdoc',
    'yaml',
}

vim.treesitter.language.register('angular', 'htmlangular')

local function install_treesitter_parsers()
    if vim.fn.executable('tree-sitter') == 1 then
        require('nvim-treesitter').install(treesitter_languages)
    end
end

install_treesitter_parsers()

vim.api.nvim_create_autocmd('User', {
    pattern = 'MasonToolsUpdateCompleted',
    group = vim.api.nvim_create_augroup('treesitter-install', { clear = true }),
    callback = install_treesitter_parsers,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = {
        'angular',
        'bash',
        'css',
        'html',
        'htmlangular',
        'javascript',
        'javascriptreact',
        'json',
        'jsonc',
        'lua',
        'markdown',
        'scss',
        'typescript',
        'typescriptreact',
        'yaml',
    },
    group = vim.api.nvim_create_augroup('treesitter-highlight', { clear = true }),
    callback = function(event)
        pcall(vim.treesitter.start, event.buf)
    end,
})

require('trouble').setup({})

vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>', { desc = 'Diagnostics' })
vim.keymap.set('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>',
    { desc = 'Buffer Diagnostics' })
vim.keymap.set('n', '<leader>cs', '<cmd>Trouble symbols toggle focus=false<CR>', { desc = 'Document Symbols' })
vim.keymap.set('n', '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<CR>',
    { desc = 'LSP References' })
