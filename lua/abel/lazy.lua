-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

local lazy = require("lazy")

-- Import every category folder under lua/abel/plugins/ automatically.
-- To add a plugin: create a file in the matching category folder.
-- To add a category: create a new folder; no changes needed here.
local spec = {}
local has_loose_files = false
for name, type in vim.fs.dir(vim.fn.stdpath("config") .. "/lua/abel/plugins") do
	if type == "directory" then
		table.insert(spec, { import = "abel.plugins." .. name })
	elseif name:sub(-4) == ".lua" then
		has_loose_files = true
	end
end
-- Loose files directly in plugins/ still work
if has_loose_files then
	table.insert(spec, { import = "abel.plugins" })
end

lazy.setup({
	spec = spec,
	install = { colorscheme = { "catppuccin" } },
	checker = { enabled = true },
})
