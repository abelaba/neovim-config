-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors    = true
vim.opt.fileformats      = "unix,dos,mac"
vim.wo.number            = true
vim.opt.tabstop          = 2
vim.opt.shiftwidth       = 2
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader          = " "
vim.g.maplocalleader     = "\\"
vim.opt.foldmethod       = "indent"
vim.opt.foldlevel        = 99
vim.opt.fillchars:append({ eob = " " })

-- Persistent undo: per-file undo history survives buffer reloads,
-- so external edits (e.g. by coding agents) can always be undone
vim.opt.undofile         = true

-- Reload buffers when files change on disk (e.g. edited by a coding agent)
vim.opt.autoread         = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "TermLeave", "TermClose" }, {
	callback = function()
		if vim.fn.getcmdwintype() == "" then
			vim.cmd("checktime")
		end
	end,
})
-- vim.opt.shell = "cmd"
--
local is_windows = vim.fn.has("win32") == 1
if is_windows then
	vim.o.shellcmdflag = "-NoLogo -NoProfile -Command" -- Make sure to setup mapleader and maplocalleader before
	vim.o.shellquote = [["]]
	vim.o.shellxquote = ""
end

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

require("abel.neovide")
require("abel.lazy")
require("abel.config")

-- setup must be called before loading
vim.cmd.colorscheme("catppuccin")
