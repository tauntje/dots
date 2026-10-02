vim.pack.add({
    { src = 'https://github.com/mason-org/mason.nvim' },
    { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/stevearc/conform.nvim' },
    { src = 'https://github.com/saghen/blink.cmp',            version = vim.version.range('^1') },
    { src = 'https://github.com/rafamadriz/friendly-snippets' },
})

vim.filetype.add({
    extension = {
        mdx = 'markdown',
        xsl = 'xslt',
    },
    pattern = {
        ['.*%.component%.html'] = 'htmlangular',
    },
})

vim.diagnostic.config({
    float = { border = 'rounded', source = 'if_many' },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    virtual_text = { spacing = 2, source = 'if_many' },
})

require('mason').setup({ PATH = 'prepend' })
require('mason-tool-installer').setup({
    ensure_installed = {
        'angular-language-server',
        'bash-language-server',
        'css-lsp',
        'eslint-lsp',
        'html-lsp',
        'lemminx',
        'lua-language-server',
        'marksman',
        'prettier',
        'tree-sitter-cli',
        'typescript-language-server',
    },
    run_on_start = true,
})

vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            workspace = {
                library = vim.api.nvim_get_runtime_file('', true)
            },
        }
    }
})

vim.lsp.config('angularls', {
    filetypes = { 'typescript', 'html', 'typescriptreact', 'htmlangular' },
    cmd = function(dispatchers, config)
        local root = config.root or config.root_dir or vim.fn.getcwd()
        local project_node_modules = vim.fs.joinpath(root, 'node_modules')
        local ts_probe_locations = { project_node_modules }
        local ng_probe_locations = { project_node_modules }
        local ngserver = vim.fn.exepath('ngserver')

        if ngserver ~= '' then
            local realpath = vim.uv.fs_realpath(ngserver) or ngserver
            local mason_node_modules = vim.fs.normalize(vim.fs.joinpath(
                vim.fs.dirname(realpath),
                '../../node_modules'
            ))
            local mason_angular_node_modules = vim.fs.joinpath(
                mason_node_modules,
                '@angular/language-server/node_modules'
            )

            if vim.uv.fs_stat(mason_node_modules) then
                table.insert(ts_probe_locations, mason_node_modules)
            end
            if vim.uv.fs_stat(mason_angular_node_modules) then
                table.insert(ng_probe_locations, mason_angular_node_modules)
            end
        else
            ngserver = 'ngserver'
        end

        local angular_core_version = ''
        local package_file = io.open(vim.fs.joinpath(root, 'package.json'), 'r')
        if package_file then
            local ok, package = pcall(vim.json.decode, package_file:read('*a'))
            package_file:close()
            if ok and package and package.dependencies and package.dependencies['@angular/core'] then
                angular_core_version = package.dependencies['@angular/core']:match('%d+%.%d+%.%d+') or ''
            end
        end

        return vim.lsp.rpc.start({
            ngserver,
            '--stdio',
            '--tsProbeLocations',
            table.concat(ts_probe_locations, ','),
            '--ngProbeLocations',
            table.concat(ng_probe_locations, ','),
            '--angularCoreVersion',
            angular_core_version,
        }, dispatchers)
    end,
})

local eslint_before_init = vim.lsp.config['eslint'].before_init
vim.lsp.config('eslint', {
    filetypes = {
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
        'vue',
        'svelte',
        'astro',
        'htmlangular',
    },
    settings = {
        experimental = { useFlatConfig = false },
    },
    before_init = function(params, config)
        if eslint_before_init then
            eslint_before_init(params, config)
        end

        config.settings = config.settings or {}
        config.settings.experimental = config.settings.experimental or {}
        config.settings.experimental.useFlatConfig = false
    end,
})

vim.lsp.config('ts_ls', {
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
})

vim.lsp.config('marksman', { filetypes = { 'markdown' } })
vim.lsp.config('lemminx', { filetypes = { 'xml', 'xsd', 'xslt', 'svg' } })

vim.lsp.enable({
    'lua_ls',
    'ts_ls',
    'bashls',
    'marksman',
    'lemminx',
    'angularls',
    'html',
    'cssls',
    'eslint',
})
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
        local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end
        map('<leader>R', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, 'Code [A]ction', { 'n', 'x' })
        map('<leader>co', function()
            if vim.fn.exists(':LspTypescriptSourceAction') == 2 then
                vim.cmd('LspTypescriptSourceAction')
            else
                vim.lsp.buf.code_action({ context = { only = { 'source' } } })
            end
        end, 'TypeScript source actions')
        map('<leader>ef', function()
            if vim.fn.exists(':LspEslintFixAll') == 2 then
                vim.cmd('LspEslintFixAll')
            end
        end, 'ESLint Fix All')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        map('[d', vim.diagnostic.goto_prev, 'Previous Diagnostic')
        map(']d', vim.diagnostic.goto_next, 'Next Diagnostic')
        map('<leader>e', vim.diagnostic.open_float, 'Line Diagnostics')
        map('<leader>ih', function()
            if vim.lsp.inlay_hint then
                local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
                vim.lsp.inlay_hint.enable(not enabled, { bufnr = event.buf })
            end
        end, 'Toggle Inlay Hints')
    end,
})

require('conform').setup({
    formatters_by_ft = {
        css = { 'prettier' },
        html = { 'prettier' },
        htmlangular = { 'prettier' },
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        json = { 'prettier' },
        jsonc = { 'prettier' },
        less = { 'prettier' },
        markdown = { 'prettier' },
        scss = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        ['typescript.tsx'] = { 'prettier' },
        yaml = { 'prettier' },
    },
    formatters = {
        prettier = {
            options = {
                ft_parsers = { htmlangular = 'angular' },
            },
        },
    },
    format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
        end

        return { lsp_format = 'fallback', timeout_ms = 1000 }
    end,
})

require('blink.cmp').setup({
    fuzzy = { implementation = 'prefer_rust_with_warning' },
    signature = { enabled = true },
    keymap = {
        preset = 'default',
        ['<Tab>'] = { 'select_and_accept' },
        ['<S-Tab>'] = {},
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-y>'] = { 'select_and_accept' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<C-n>'] = { 'select_next', 'fallback' },
        ['<C-j>'] = { 'scroll_documentation_down', 'fallback' },
        ['<C-k>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-l>'] = { 'snippet_forward', 'fallback' },
        ['<C-h>'] = { 'snippet_backward', 'fallback' },
    },
    appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'normal',
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
    sources = { default = { 'lsp', 'snippets' } },
})
