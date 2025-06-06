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

-- ======================
--      Neovide Setup
-- ======================
if vim.g.neovide then
	-- Font
	vim.o.guifont = "Hack Nerd Font:h10" -- Set your preferred font and size
	vim.g.neovide_fullscreen = false -- Start Neovide in fullscreen mode

	-- Cursor Effects
	-- vim.g.neovide_cursor_vfx_mode = "lightbulb" -- Options: 'pixiedust', 'torpedo', 'ripple', 'wireframe', 'sonicboom', 'railgun', 'lightbulb'
	vim.g.neovide_cursor_animation_length = 0.05
	vim.g.neovide_cursor_trail_size = 0.1
	vim.g.neovide_cursor_antialiasing = true
	vim.g.neovide_cursor_animate_command_line = true

	-- Transparency
	vim.g.neovide_opacity = 0.9

	-- Floating Blur (if transparency is used)
	vim.g.neovide_floating_blur_amount_x = 2.0
	vim.g.neovide_floating_blur_amount_y = 2.0

	-- Remember window size
	vim.g.neovide_remember_window_size = true

	-- Scroll animation
	vim.g.neovide_scroll_animation_length = 0.3

	-- Theme
	vim.g.neovide_theme = "dark" -- 'auto', 'dark', or 'light'

	-- Logo (⌘ key) support on macOS or Windows
	vim.g.neovide_input_use_logo = true

	-- Hide mouse when typing
	vim.g.neovide_hide_mouse_when_typing = true
	vim.cmd([[highlight Normal guibg=#282A36]])
	vim.keymap.set("n", "<F11>", function()
		vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
	end, { desc = "Toggle Neovide Fullscreen" })
end

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

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{
			"ahmedkhalf/project.nvim",
			config = function()
				require("project_nvim").setup({
					-- your configuration comes here
					-- or leave it empty to use the default settings
					-- refer to the configuration section below
				})
			end,
		},
		{
			"stevearc/overseer.nvim",
			opts = {},
		},
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
			dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},

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
			"Exafunction/windsurf.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"hrsh7th/nvim-cmp",
			},
			config = function()
				require("codeium").setup({})
			end,
		},
		{
			"stevearc/conform.nvim",
			opts = {},
		},
		-- {
		-- 	"github/copilot.vim",
		-- 	lazy = false,
		-- },

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
				{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
			},
		},
	},

	-- Plugin Manager Settings
	install = { colorscheme = { "vscode" } },
	checker = { enabled = false },
})

require("overseer").setup()
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
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
		},
	},
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
telescope.load_extension("fzf")

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
		python = { "ruff" },
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
		a = { fg = colors.black, bg = colors.white },
		b = { fg = colors.white, bg = colors.black },
		c = { fg = colors.white, bg = colors.black },
	},
	insert = { a = { fg = colors.black, bg = colors.blue } },
	visual = { a = { fg = colors.black, bg = colors.cyan } },
	replace = { a = { fg = colors.black, bg = colors.red } },
	command = { a = { fg = colors.black, bg = colors.yellow } },
	inactive = {
		a = { fg = colors.white, bg = colors.black },
		b = { fg = colors.white, bg = colors.black },
		c = { fg = colors.white, bg = colors.black },
	},
}

local emojis = {
	"ᕙ(⇀‸↼‶)ᕗ",
	"(ง •̀_•́)ง",
	"ˁ˚ᴥ˚ˀ",
	"❚█══█❚",
	"┌∩┐(◣_◢)┌∩┐",
	"d[-_-]b",
	"[¬º-°]¬",
	"(‾⌣‾)",
	"╰(°▽°)╯",
}
local current_emoji = emojis[1]
local last_update = 0

local function get_wiggly_emoji()
	local now = os.time()

	-- Update every x seconds (adjust as desired)
	if now - last_update > 10 then
		last_update = now
		math.randomseed(os.time() + math.random(1000))

		local base = emojis[math.random(#emojis)]

		current_emoji = base
	end

	return current_emoji
end

require("lualine").setup({
	options = {
		disabled_filetypes = { "lazy", "NvimTree", "alpha", "TelescopePrompt", "TelescopeResults" },
		theme = neon_theme,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		icons_enabled = true,
		globalstatus = true,
		always_show_tabline = true,
	},
	sections = {
		lualine_a = {
			{ "mode", right_padding = 2 },
		},
		lualine_b = {
			{ "branch", icon = "", symbols = { modified = " ●", readonly = " x" } },
			{
				"diff",
				symbols = { added = " ", modified = " ", removed = " " },
			},
		},
		lualine_c = {
			{
				"filename",
				path = 1,
				symbols = { modified = "*", readonly = "x", unnamed = "[No Name]" },
			},
			{ "filetype", icon_only = true },
		},

		lualine_x = {},
		lualine_y = { { "progress" } },
		lualine_z = { { "location" } },
	},
	inactive_sections = {
		lualine_a = { { "filename", path = 1 }, { "filetype", icon_only = true } },
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {
		lualine_a = {},
		lualine_b = {},
		lualine_x = {
			function()
				return get_wiggly_emoji()
			end,
		},
		lualine_y = {},

		lualine_c = {
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
	eextensions = { "nvim-tree" },
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
require("nvim-tree").setup({
	sync_root_with_cwd = true,
	respect_buf_cwd = true,
	update_focused_file = {
		enable = true,
		update_root = true,
	},
})

require("abel.keymaps")
