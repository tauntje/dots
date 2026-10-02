local languages = {
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

local function install_parsers()
  if vim.fn.executable('tree-sitter') == 1 then
    require('nvim-treesitter').install(languages)
  end
end

install_parsers()

vim.api.nvim_create_autocmd('User', {
  pattern = 'MasonToolsUpdateCompleted',
  group = vim.api.nvim_create_augroup('treesitter-install', { clear = true }),
  callback = install_parsers,
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
