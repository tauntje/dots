local opt = vim.o

-- gui options
opt.termguicolors = true
opt.winborder = "rounded"
opt.number = true
opt.relativenumber = true

-- autocomplete
opt.completeopt = "noinsert,menuone,popup"

-- command line completion
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.wildignore:append({ "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })

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

