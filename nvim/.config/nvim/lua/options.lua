local opt = vim.o

-- gui options
opt.wrap = false
opt.termguicolors = true
opt.winborder = "rounded"
opt.number = true
opt.relativenumber = true
opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

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

-- undo files
opt.undofile = true

-- misc
vim.cmd("set noswapfile")
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)
