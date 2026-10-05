-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.snacks_animate = false

-- Use WSLg's Wayland clipboard bridge to share with Windows without starting
-- a Windows process for every clipboard operation.
local wl_copy = "/home/ahorguel/.local/bin/wl-copy"
local wl_paste = "/home/ahorguel/.local/bin/wl-paste"

vim.g.clipboard = {
  name = "WslgClipboard",
  copy = {
    ["+"] = { wl_copy },
    ["*"] = { wl_copy },
  },
  paste = {
    ["+"] = { wl_paste, "--no-newline" },
    ["*"] = { wl_paste, "--no-newline" },
  },
  cache_enabled = 0,
}

vim.opt.clipboard = "unnamedplus"
