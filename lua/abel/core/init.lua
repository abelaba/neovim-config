-- disable netrw at the very start of your init.lua
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true
vim.opt.fileformats = "unix,dos,mac"
vim.wo.number = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shell = "pwsh"
-- Make sure to setup mapleader and maplocalleader before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.fillchars:append({ eob = " " })

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