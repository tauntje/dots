local opt = vim.o

-- Display
opt.wrap = false
opt.termguicolors = true
opt.winborder = 'rounded'
opt.number = true
opt.relativenumber = true
opt.signcolumn = 'yes'
opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Completion and command-line completion
opt.completeopt = 'noinsert,menuone,popup'
vim.opt.wildmenu = true
vim.opt.wildmode = 'longest:full,full'
vim.opt.wildignore:append({ '*.o', '*.obj', '*.pyc', '*.class', '*.jar' })

-- Indentation and scrolling
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.scrolloff = 10
opt.splitright = true
opt.splitbelow = true

-- Search
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.showmode = true

-- Files and persistence
opt.undofile = true
opt.swapfile = false

opt.clipboard = 'unnamedplus'
