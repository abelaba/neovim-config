-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.shell = "pwsh"
vim.o.shellcmdflag = "-NoLogo -NoProfile -Command" -- Make sure to setup mapleader and maplocalleader before
vim.o.shellquote = [["]]
vim.o.shellxquote = ""
require("config.neovide")
