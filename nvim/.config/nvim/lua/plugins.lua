vim.pack.add({
    { src = "https://github.com/folke/tokyonight.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/nvim-mini/mini.pick" },
    { src = "https://github.com/nvim-mini/mini.extra" },
    { src = "https://github.com/ThePrimeagen/harpoon", version="harpoon2"},
    { src = "https://github.com/shortcuts/no-neck-pain.nvim" },
    { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" }
})
-- most important part
vim.cmd("colorscheme tokyonight-storm")

-- fuzzy finder
require("mini.extra").setup()
require("mini.pick").setup()
vim.keymap.set("n", "<leader>f", ":Pick files<CR>")
vim.keymap.set("n", "<leader>gd", ":Pick lsp scope=('definition')<CR>")
vim.keymap.set("n", "<leader>ds", ":Pick lsp scope=('document_symbol')<CR>")
vim.keymap.set("n", "<leader>sw", ":Pick grep live<CR><CR>")
vim.keymap.set("n", "<leader>sh", ":Pick help<CR>")

-- harpoon
local harpoon = require("harpoon")
harpoon:setup({
    settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
    }
})

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
