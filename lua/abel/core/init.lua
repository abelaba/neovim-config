-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true
vim.opt.fileformats = "unix,dos,mac"
vim.wo.number = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.fillchars:append({ eob = " " })
vim.opt.shell = "pwsh"
vim.o.shellcmdflag = "-NoLogo -NoProfile -Command" -- Make sure to setup mapleader and maplocalleader before
vim.o.shellquote = [["]]
vim.o.shellxquote = ""

-- vim.g.clipboard = {
-- 	name = "clip-wsl",
-- 	copy = {
-- 		["+"] = "clip.exe",
-- 		["*"] = "clip.exe",
-- 	},
-- 	paste = {
-- 		["+"] = "powershell.exe -noprofile -command 'Get-Clipboard'",
-- 		["*"] = "powershell.exe -noprofile -command 'Get-Clipboard'",
-- 	},
-- 	cache_enabled = true,
-- }

require("abel.core.neovide")
