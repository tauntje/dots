vim.cmd([[
 setlocal spelllang=fr
 setlocal spell
 setlocal linebreak
 setlocal wrap
 setlocal wrapmargin=10
 setlocal formatoptions+=t
]])
vim.keymap.set("n", "<leader>c", "1z=")
require("no-neck-pain").setup({ 
    autocmds={
          enableOnVimEnter = true,
    }
})
