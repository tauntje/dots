# Neovim configuration

This config uses Neovim's built-in `vim.pack` plugin manager and requires Neovim 0.12 or newer.

## Where things live

- `init.lua` — sets leaders and loads core settings, then plugins.
- `lua/core/` — editor options, keymaps, and autocmds that do not depend on plugins.
- `lua/plugins/specs.lua` — the complete plugin list. Add new plugin sources here.
- `lua/plugins/init.lua` — loads the plugin list, then each feature's setup module.
- `lua/plugins/*.lua` — plugin setup grouped by feature: UI, navigation, editing, Treesitter, diagnostics, and LSP.
- `after/ftplugin/` — settings that apply only to a filetype, currently Markdown.
- `nvim-pack-lock.json` — generated and maintained by `vim.pack`; don't edit it by hand.

## Adding or changing things

- For a new plugin, add its source to `lua/plugins/specs.lua`, then configure it in the relevant `lua/plugins/` feature file. Add a new feature file only when it makes the grouping clearer, and load it from `lua/plugins/init.lua`.
- Language servers, formatters, and Mason-managed tools are configured in `lua/plugins/lsp.lua`.
- Treesitter parser names and filetype highlighting are in `lua/plugins/treesitter.lua`.
- Filetype-specific behavior belongs in `after/ftplugin/<filetype>.lua`.
