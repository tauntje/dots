vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Core settings are available before any plugins are configured.
require('core.options')
require('core.autocmds')
require('core.keymaps')

-- Install/load plugins, then configure them by feature.
require('plugins')
