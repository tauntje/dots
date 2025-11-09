-- deactivate keymaps
vim.keymap.set("n", "s", "<Nop>")
vim.keymap.set("n", "<C-b>", "<Nop>")

-- menu
vim.keymap.set("n", "<C-e>", vim.cmd.Ex)

-- search
vim.keymap.set("n", "<esc>", vim.cmd.nohlsearch)

-- buffer navigation
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- splits
vim.keymap.set("n", "<leader>v", "<C-w>v")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- lines
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv")

-- md specific
vim.keymap.set("v", "<leader>ft", ":! tr -s ' ' | column -t -s '|' -o '|'")

-- lsp
vim.keymap.set({"n", "v"}, "<leader>F", vim.lsp.buf.format)
