vim.pack.add({
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/saghen/blink.cmp",            version = vim.version.range("^1") },
    { src = "https://github.com/rafamadriz/friendly-snippets" }
})
vim.diagnostic.config({ virtual_text = true })
require("mason").setup()

vim.lsp.enable({ "lua_ls", "ts_ls", "bash-language-server", "marksman", "lemminx", "prettier", "angular-language-server" })
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true)
            },
        }
    }
})

require('blink.cmp').setup({
    fuzzy = { implementation = 'prefer_rust_with_warning' },
    signature = { enabled = true },
    keymap = {
        preset = "default",
        ["<Tab>"] = {},
        ["<S-Tab>"] = {},
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-y>"] = { "select_and_accept" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-j>"] = { "scroll_documentation_down", "fallback" },
        ["<C-k>"] = { "scroll_documentation_up", "fallback" },
        ["<C-l>"] = { "snippet_forward", "fallback" },
        ["<C-h>"] = { "snippet_backward", "fallback" },
    },
    appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "normal",
    },
    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
        }
    },
    cmdline = {
        keymap = {
            preset = 'inherit',
        },
        completion = { menu = { auto_show = true } },
    },
    sources = { default = { "lsp", "snippets" } },
})
