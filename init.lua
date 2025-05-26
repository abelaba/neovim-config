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
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true
vim.opt.fileformats = "unix,dos,mac"
vim.opt.rtp:prepend(lazypath)
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

vim.g.clipboard = {
	name = "clip-wsl",
	copy = {
		["+"] = "clip.exe",
		["*"] = "clip.exe",
	},
	paste = {
		["+"] = "powershell.exe -noprofile -command 'Get-Clipboard'",
		["*"] = "powershell.exe -noprofile -command 'Get-Clipboard'",
	},
	cache_enabled = true,
}

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- UI Enhancements
		{ "folke/which-key.nvim", event = "VeryLazy" },
		{ "Mofiqul/vscode.nvim" },

		-- Git Integration
		{
			"NeogitOrg/neogit",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"sindrets/diffview.nvim",
				"nvim-telescope/telescope.nvim",
			},
		},
		{ "lewis6991/gitsigns.nvim", name = "gitsigns", opts = {} },

		-- Telescope (Fuzzy Finder & Extensions)
		{
			"nvim-telescope/telescope.nvim",
			tag = "0.1.8",
			dependencies = { "nvim-lua/plenary.nvim" },
		},
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

		-- Treesitter (Syntax Highlighting & Parsing)
		{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

		-- Dashboard
		{
			"goolord/alpha-nvim",
			dependencies = { "echasnovski/mini.icons" },
			config = function()
				require("alpha").setup(require("abel.startupscreen-config").config)
			end,
		},

		-- Statusline & UI Elements
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			event = "BufReadPost",
		},
		{
			"nvim-tree/nvim-tree.lua",
			version = "*",
			lazy = false,
			dependencies = {
				"nvim-tree/nvim-web-devicons",
			},
			config = function()
				require("nvim-tree").setup({})
			end,
		},

		-- Coding Assistance
		{
			"saghen/blink.cmp",
			dependencies = { "rafamadriz/friendly-snippets" },
			version = "1.*",
			opts = {
				-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
				-- 'super-tab' for mappings similar to vscode (tab to accept)
				-- 'enter' for enter to accept
				-- 'none' for no mappings
				--
				-- All presets have the following mappings:
				-- C-space: Open menu or open docs if already open
				-- C-n/C-p or Up/Down: Select next/previous item
				-- C-e: Hide menu
				-- C-k: Toggle signature help (if signature.enabled = true)
				--
				-- See :h blink-cmp-config-keymap for defining your own keymap
				keymap = { preset = "enter" },
				signature = {
					enabled = true,
				},
				completion = { documentation = { auto_show = true } },
				fuzzy = { implementation = "lua" },
			},
			opts_extend = { "sources.default" },
		},
		{
			"Exafunction/codeium.nvim",
			dependencies = { "nvim-lua/plenary.nvim", "hrsh7th/nvim-cmp" },
		},
		{
			"stevearc/conform.nvim",
			opts = {},
		},
		{
			"github/copilot.vim",
			lazy = false,
		},

		-- LSP & Debugging
		{ "williamboman/mason.nvim" },
		{ "williamboman/mason-lspconfig.nvim" },
		{
			"neovim/nvim-lspconfig",
			dependencies = {
				"folke/lazydev.nvim",
				opts = {
					library = {
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
				},
			},
		},
		{
			"rcarriga/nvim-dap-ui",
			dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		},

		-- Flutter Development
		{
			"nvim-flutter/flutter-tools.nvim",
			lazy = false,
			dependencies = {
				"nvim-lua/plenary.nvim",
				"stevearc/dressing.nvim", -- optional for vim.ui.select
			},
			config = true,
		},

		-- LeetCode Plugin
		{
			"kawre/leetcode.nvim",
			build = ":TSUpdate html",
			dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
			opts = { arg = "l", lang = "python3" },
		},

		-- Spectre (Search & Replace)
		{ "nvim-pack/nvim-spectre" },

		-- Note Taking
		{
			"epwalsh/obsidian.nvim",
			version = "*",
			lazy = true,
			ft = "markdown",
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
		},
		{ "echasnovski/mini.cursorword", version = false },
		{
			"rachartier/tiny-inline-diagnostic.nvim",
			event = "VeryLazy", -- Or `LspAttach`
			priority = 1000, -- needs to be loaded in first
			config = function()
				require("tiny-inline-diagnostic").setup()
				vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
			end,
		},
	},

	-- Plugin Manager Settings
	install = { colorscheme = { "vscode" } },
	checker = { enabled = false },
})

require("mini.cursorword").setup({})

require("flutter-tools").setup({})
require("obsidian").setup({
	workspaces = {
		{
			name = "personal",
			path = "~/Documents/vaults/personal",
		},
	},
})

local telescope = require("telescope")
telescope.setup({
	defaults = {
		vimgrep_arguments = {
			"rg",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--glob=!**/.git/*",
			"--glob=!**/.venv/*",
			"--glob=!**/node_modules/*",
		},
	},
})
-- telescope.load_extension("fzf")

require("mason").setup()
require("mason-lspconfig").setup({
	handlers = {
		function(server_name)
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			require("lspconfig")[server_name].setup({ capabilities = capabilities })
		end,
	},
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		-- Conform will run multiple formatters sequentially
		python = { "isort", "black" },
		-- Conform will run the first available formatter
		javascript = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "prettierd", "prettier", stop_after_first = true },
		html = { "prettierd", "prettier", stop_after_first = true },
		css = { "prettierd", "prettier", stop_after_first = true },
		markdown = { "prettierd", "prettier", stop_after_first = true },
		json = { "prettierd", "prettier", stop_after_first = true },
		yaml = { "prettierd", "prettier", stop_after_first = true },
		typescriptreact = { "prettierd", "prettier", stop_after_first = true },
		javascriptreact = { "prettierd", "prettier", stop_after_first = true },
	},
	format_on_save = {
		timeout_ms = 1000,
		lsp_fallback = true,
	},
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

local colors = {
	magenta = "#ff66b2",
	blue = "#66d9ff",
	cyan = "#66ffcc",
	red = "#ff6666",
	yellow = "#ffeb66",
	black = "#202020",
	grey = "#505050",
	white = "#ffffff",
}

local neon_theme = {
	normal = {
		a = { fg = colors.black, bg = colors.white, gui = "bold" },
		b = { fg = colors.white, bg = colors.black },
		c = { fg = colors.white },
	},
	insert = { a = { fg = colors.black, bg = colors.blue, gui = "bold" } },
	visual = { a = { fg = colors.black, bg = colors.cyan, gui = "bold" } },
	replace = { a = { fg = colors.black, bg = colors.red, gui = "bold" } },
	command = { a = { fg = colors.black, bg = colors.yellow, gui = "bold" } },
	inactive = {
		a = { fg = colors.white, bg = colors.black },
		b = { fg = colors.white, bg = colors.black },
		c = { fg = colors.white },
	},
}

require("lualine").setup({
	options = {
		disabled_filetypes = { "lazy", "NvimTree" },
		theme = neon_theme,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		icons_enabled = true,
	},
	sections = {
		lualine_a = {
			{ "mode", separator = { left = "" }, right_padding = 2 },
		},
		lualine_b = {
			{ "branch", icon = "", separator = { right = "" } },
		},
	},
	lualine_c = {
		{ "filepath", path = 1, symbols = { modified = "*", readonly = "x", unnamed = "[No Name]" } },
	},
	lualine_x = { "encoding", "filetype" },
	lualine_y = { "progress", separator = { left = "" } },
	lualine_z = { { "location", separator = { right = "" } } },
	inactive_sections = {
		lualine_a = { { "filepath", path = 1 } },
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = { "location" },
	},
	tabline = {
		lualine_a = {
			{
				function()
					local buffers = {}
					for _, buf in ipairs(vim.api.nvim_list_bufs()) do
						if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, "modified") then
							local bufname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
							table.insert(buffers, bufname .. " ●")
						end
					end
					return table.concat(buffers, " | ")
				end,
				color = { fg = "#ffffff", bg = "#4c566a", gui = "bold" },
			},
		},
	},
	extensions = {},
})

local c = require("vscode.colors").get_colors()
require("vscode").setup({
	transparent = true,
	italic_comments = true,
	underline_links = true,
	disable_nvimtree_bg = true,
	color_overrides = {
		vscLineNumber = "#FFFFFF",
	},
	group_overrides = {
		Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
	},
})

vim.cmd.colorscheme("vscode")

require("gitsigns").setup({
	signs = {
		add = { text = "┃" },
		change = { text = "┃" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	signs_staged = {
		add = { text = "┃" },
		change = { text = "┃" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	signs_staged_enable = true,
	signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
	numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
	linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
	word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
	watch_gitdir = {
		follow_files = true,
	},
	auto_attach = true,
	attach_to_untracked = false,
	current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
		delay = 1000,
		ignore_whitespace = false,
		virt_text_priority = 100,
		use_focus = true,
	},
	current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
	sign_priority = 6,
	update_debounce = 100,
	status_formatter = nil, -- Use default
	max_file_length = 40000, -- Disable if file is longer than this (in lines)
	preview_config = {
		-- Options passed to nvim_open_win
		border = "single",
		style = "minimal",
		relative = "cursor",
		row = 0,
		col = 1,
	},
	on_attach = function(bufnr)
		local gitsigns = require("gitsigns")

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				gitsigns.nav_hunk("next")
			end
		end)

		map("n", "[c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				gitsigns.nav_hunk("prev")
			end
		end)
	end,
})

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"lua",
		"python",
		"javascript",
		"typescript",
	},
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})

-- Hide statusline, tabline, line numbers, and sign column on Alpha
vim.api.nvim_create_autocmd("User", {
	pattern = "AlphaReady",
	callback = function()
		vim.cmd([[
		set laststatus=0
		set showtabline=0
		]])
	end,
})

-- Restore UI elements after leaving Alpha
vim.api.nvim_create_autocmd("BufUnload", {
	pattern = "*",
	callback = function()
		vim.cmd([[
		set laststatus=2
		set showtabline=2
		]])
	end,
})

require("abel.keymaps")
