require('abel')
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
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

vim.opt.rtp:prepend(lazypath)
vim.wo.relativenumber = true
-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"


vim.keymap.set('n', '<leader>bb', ':Neotree toggle focus<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>bf', ':Neotree focus<CR>', { noremap = true, silent = true })
-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- add your plugins here
		{
			'nvim-telescope/telescope.nvim', tag = '0.1.8',
			dependencies = { 'nvim-lua/plenary.nvim' }
		},
		{ "rose-pine/neovim", name = "rose-pine" },
		{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
		{
			"NeogitOrg/neogit",
			dependencies = {
				"nvim-lua/plenary.nvim", 
				"sindrets/diffview.nvim",
			},
			config = true
		},
		{
			"startup-nvim/startup.nvim",
			dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim", "nvim-telescope/telescope-file-browser.nvim" },
			config = function()
				require "startup".setup(require'abel.startup')
			end
		},
		{ "lewis6991/gitsigns.nvim", name = "gitsigns" },
		{
			'nvim-lualine/lualine.nvim',
			dependencies = { 'nvim-tree/nvim-web-devicons' },
			config = function()
				require('lualine').setup()
			end
		},
		{
			"folke/which-key.nvim",
			event = "VeryLazy",
			keys = {
				{
					"<leader>?",
					function()
						require("which-key").show({ global = false })
					end,
					desc = "Buffer Local Keymaps (which-key)",
				},
			},
		},
		{
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v3.x",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
				"MunifTanjim/nui.nvim",
				"3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
			}
		},
		{
			"kawre/leetcode.nvim",
			build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
			dependencies = {
				"nvim-telescope/telescope.nvim",
				"nvim-lua/plenary.nvim",
				"MunifTanjim/nui.nvim",
			},
		},
		{
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
		},
		{
			"Mofiqul/vscode.nvim",
		},
		{
			"ThePrimeagen/harpoon",
			branch = "harpoon2",
			dependencies = { "nvim-lua/plenary.nvim" }
		},
		{
			"Exafunction/codeium.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"hrsh7th/nvim-cmp",
			},
		},
		{
			'hrsh7th/nvim-cmp',
			dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
		},
		{
			"folke/noice.nvim",
			event = "VeryLazy",
			dependencies = {
				-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
				"MunifTanjim/nui.nvim",
				"rcarriga/nvim-notify",
			}
		},
		{ 'mhartington/formatter.nvim' }

	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "vscode" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})

require('mason').setup({})
require('mason-lspconfig').setup({
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
  },
})

vim.api.nvim_create_user_command("Cod", function()
  local virtual_text = require("codeium.config").options.virtual_text
  virtual_text.manual = not virtual_text.manual
  print("Codeium virtual text is now " .. (not virtual_text.manual and "enabled" or "disabled"))
end, { desc = "Toggle Codeium virtual text" })

require("formatter").setup({
	logging = true,
	filetype = {
		lua = { require("formatter.filetypes.lua").stylua },
		javascript = { require("formatter.filetypes.javascript").prettier },
		typescript = { require("formatter.filetypes.javascript").prettier },
		javascriptreact = { require("formatter.filetypes.javascript").prettier },
		typescriptreact = { require("formatter.filetypes.javascript").prettier },
	},
})

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*", 
    callback = function()
        vim.cmd("FormatWrite")
    end,
})

require("notify").setup({
  background_colour = "#000000",
})

