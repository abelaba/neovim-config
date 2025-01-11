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
-- Make sure to setup mapleader and maplocalleader before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"


vim.keymap.set('n', '<leader>bb', ':Neotree toggle reveal_force_cwd focus<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>bf', ':Neotree focus<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>`', ':ToggleTerm<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>cc', function()
  local virtual_text = require("codeium.config").options.virtual_text
  virtual_text.manual = not virtual_text.manual
  print("Codeium virtual text is now " .. (not virtual_text.manual and "enabled" or "disabled"))
end, { noremap = true, silent = true, desc = "Toggle Codeium virtual text" })

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
		-- {
			--	"NeogitOrg/neogit",
			--	dependencies = {
				--		"nvim-lua/plenary.nvim", 
				--		"sindrets/diffview.nvim",
				--	},
				--	config = true
				-- },
				{
					"kdheepak/lazygit.nvim",
					lazy = true,
					cmd = {
						"LazyGit",
						"LazyGitConfig",
						"LazyGitCurrentFile",
						"LazyGitFilter",
						"LazyGitFilterCurrentFile",
					},
					-- optional for floating window border decoration
					dependencies = {
						"nvim-lua/plenary.nvim",
					},
					-- setting the keybinding for LazyGit with 'keys' is recommended in
					-- order to load the plugin when the command is run for the first time
					keys = {
						{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
					},
					config = function ()
						require("telescope").load_extension("lazygit")
					end
				},
				{
					'nvimdev/dashboard-nvim',
					event = 'VimEnter',
					opts = {
						theme = 'hyper',
						config = require 'abel.dashboard-config',
					},
					dependencies = { {'nvim-tree/nvim-web-devicons'}}
				},
				{ "lewis6991/gitsigns.nvim", name = "gitsigns" },
				{
					'nvim-lualine/lualine.nvim',
					dependencies = { 'nvim-tree/nvim-web-devicons' },
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
						"3rd/image.nvim", -- Optional image support in preview window: See # Preview Mode for more information
					}
				},
				{
					"kawre/leetcode.nvim",
					build = ":TSUpdate html", -- if you have nvim-treesitter installed
					dependencies = {
						"nvim-telescope/telescope.nvim",
						"nvim-lua/plenary.nvim",
						"MunifTanjim/nui.nvim",
					},
					opts = {}
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
						"MunifTanjim/nui.nvim",
						"rcarriga/nvim-notify",
					}
				},
				{ 'mhartington/formatter.nvim' },
				{
					'nvim-flutter/flutter-tools.nvim',
					lazy = false,
					dependencies = {
						'nvim-lua/plenary.nvim',
						'stevearc/dressing.nvim', -- optional for vim.ui.select
					},
					config = true,
				},
				{'akinsho/toggleterm.nvim', version = "*", opts = { direction = 'float', size = 20 }},
				{'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},
				{
					"karb94/neoscroll.nvim",
					opts = {},
				},
				--{
				--	"m4xshen/hardtime.nvim",
				--	dependencies = { "MunifTanjim/nui.nvim" },
				--	opts = {}
				-- },
				{
					'tamton-aquib/duck.nvim',
					config = function()
						vim.keymap.set('n', '<leader>dd', function() require("duck").hatch("🦍") end, {})
						vim.keymap.set('n', '<leader>dk', function() require("duck").cook() end, {})
						vim.keymap.set('n', '<leader>da', function() require("duck").cook_all() end, {})
					end
				}
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

require("flutter-tools").setup {}
require('neoscroll').setup({
	mappings = {                 -- Keys to be mapped to their corresponding default scrolling animation
		'<C-u>', '<C-d>',
		'<C-b>', '<C-f>',
		'<C-y>', '<C-e>',
		'zt', 'zz', 'zb',
	},
	hide_cursor = true,          -- Hide cursor while scrolling
	stop_eof = true,             -- Stop at <EOF> when scrolling downwards
	respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
	cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
	duration_multiplier = 1.0,   -- Global duration multiplier
	easing = 'linear',           -- Default easing function
	pre_hook = nil,              -- Function to run before the scrolling animation starts
	post_hook = nil,             -- Function to run after the scrolling animation ends
	performance_mode = false,    -- Disable "Performance Mode" on all buffers.
})
require("bufferline").setup{}

function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
