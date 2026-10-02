-- Keep every plugin declaration in this file so the plugin inventory is easy
-- to find. vim.pack installs and loads these before feature setup modules run.
return {
  -- Shared dependency
  { src = 'https://github.com/nvim-lua/plenary.nvim' },

  -- Search and navigation
  { src = 'https://github.com/nvim-telescope/telescope.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope-ui-select.nvim' },
  { src = 'https://github.com/ThePrimeagen/harpoon', version = 'harpoon2' },

  -- Editing and interface
  { src = 'https://github.com/nvim-mini/mini.nvim' },
  { src = 'https://github.com/catppuccin/nvim' },
  { src = 'https://github.com/shortcuts/no-neck-pain.nvim' },
  { src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim' },
  { src = 'https://github.com/folke/trouble.nvim' },

  -- Syntax, language servers, completion, and formatting
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  { src = 'https://github.com/mason-org/mason.nvim' },
  { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/stevearc/conform.nvim' },
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('^1') },
  { src = 'https://github.com/rafamadriz/friendly-snippets' },
}
