vim.g.mapleader = " "
local opt = vim.o

-- gui options
opt.termguicolors = true
opt.winborder = "rounded"
opt.number = true
opt.relativenumber = true

-- autocomplete
opt.completeopt = "noinsert,menuone,popup"

-- tabs and scrolloff
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.scrolloff = 10

-- search
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.showmode = true

-- misc
vim.cmd("set noswapfile")
vim.cmd("set clipboard=unnamedplus")

-- md specific
--
-- vim.cmd("set spelllang=fr")
-- local isWriteMode = false
-- vim.keymap.set("n", "<leader>tp",
--     function()
--         if (not isWriteMode) then
--             vim.cmd("set spelllang=fr")
--             vim.cmd("set spell")
--             vim.cmd("set linebreak")
--             vim.keymap.set("n", "j", "gj")
--             vim.keymap.set("n", "k", "gk")
--             isWriteMode = true
--             else
--             vim.cmd("set spell!")
--             vim.cmd("set linebreak!")
--             vim.keymap.set("n", "j", "j")
--             vim.keymap.set("n", "k", "k")
--             isWriteMode = false
--         end
--     end
-- )

