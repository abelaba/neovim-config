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
vim.opt.shiftwidth = 4
-- Make sure to setup mapleader and maplocalleader before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

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
		{ "folke/noice.nvim", event = "VeryLazy", dependencies = { "MunifTanjim/nui.nvim" } },
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
				require("alpha").setup(require("abel.dashboard-config").config)
			end,
		},

		-- Statusline & UI Elements
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			event = "BufReadPost",
		},
		{
			"stevearc/oil.nvim",
			opts = {},
			-- Optional dependencies
			dependencies = { { "echasnovski/mini.icons", opts = {} } },
			lazy = false,
		},

		-- Coding Assistance
		{
			"hrsh7th/nvim-cmp",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"L3MON4D3/LuaSnip",
				"saadparwaiz1/cmp_luasnip",
			},
		},
		{
			"Exafunction/codeium.nvim",
			dependencies = { "nvim-lua/plenary.nvim", "hrsh7th/nvim-cmp" },
		},
		{ "mhartington/formatter.nvim" },

		-- LSP & Debugging
		{ "williamboman/mason.nvim" },
		{ "williamboman/mason-lspconfig.nvim" },
		{ "neovim/nvim-lspconfig" },
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
	},

	-- Plugin Manager Settings
	install = { colorscheme = { "vscode" } },
	checker = { enabled = true },
})

require("flutter-tools").setup({})

require("telescope").setup({
	defaults = {
		vimgrep_arguments = { "rg", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },
	},
})
require("telescope").load_extension("fzf")

require("mason").setup({})
require("mason-lspconfig").setup({
	handlers = {
		function(server_name)
			require("lspconfig")[server_name].setup({})
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

require("lspconfig").lua_ls.setup({
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" }, -- Recognize 'vim' as a global variable
			},
		},
	},
})

require("noice").setup({
	lsp = {
		-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
		},
	},
	-- you can enable a preset for easier configuration
	presets = {
		bottom_search = true, -- use a classic bottom cmdline for search
		command_palette = true, -- position the cmdline and popupmenu together
		long_message_to_split = true, -- long messages will be sent to a split
		inc_rename = false, -- enables an input dialog for inc-rename.nvim
		lsp_doc_border = false, -- add a border to hover docs and signature help
	},
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
		theme = neon_theme,
		component_separators = { left = "|", right = "|" },
		section_separators = { left = "", right = "" },
		icons_enabled = true,
	},
	sections = {
		lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
		lualine_b = {
			{ "branch", icon = "🌿" },
		},
		lualine_c = {
			{ "filename", path = 1, symbols = { modified = "*", readonly = "", unnamed = "[No Name]" } },
		},
		lualine_x = { "encoding", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { { "location", separator = { right = "" } } },
	},
	inactive_sections = {
		lualine_a = { { "filename", path = 1 } },
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = { "location" },
	},
	tabline = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
	},
	extensions = {},
})

require("codeium").setup({
	enable_cmp_source = false,
	virtual_text = {
		enabled = true,

		manual = false,
		filetypes = {},
		default_filetype_enabled = true,
		idle_delay = 75,
		virtual_text_priority = 65535,
		map_keys = true,
		accept_fallback = nil,
		key_bindings = {
			accept = "<C-e>",
			accept_word = false,
			accept_line = false,
			clear = false,
			next = "<M-]>",
			prev = "<M-[>",
		},
	},
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
		add = { text = "â”ƒ" },
		change = { text = "â”ƒ" },
		delete = { text = "_" },
		topdelete = { text = "â€¾" },
		changedelete = { text = "~" },
		untracked = { text = "â”†" },
	},
	signs_staged = {
		add = { text = "â”ƒ" },
		change = { text = "â”ƒ" },
		delete = { text = "_" },
		topdelete = { text = "â€¾" },
		changedelete = { text = "~" },
		untracked = { text = "â”†" },
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

		-- Actions
		map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk" })
		map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk" })
		map("v", "<leader>hs", function()
			gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "Stage hunk" })
		map("v", "<leader>hr", function()
			gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "Reset hunk" })
		map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage buffer" })
		map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "Undo stage hunk" })
		map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset buffer" })
		map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk" })
		map("n", "<leader>hb", function()
			gitsigns.blame_line({ full = true })
		end, { desc = "Blame line" })
		map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle current line blame" })
		map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff this" })
		map("n", "<leader>hD", function()
			gitsigns.diffthis("~")
		end, { desc = "Diff this ~" })
		map("n", "<leader>td", gitsigns.toggle_deleted, { desc = "Toggle deleted" })

		-- Text object
		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
	end,
})

-- nvim-cmp setup
local cmp = require("cmp")
local luasnip = require("luasnip")

luasnip.config.setup({})

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete({}),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	},
})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>q", function()
	builtin.live_grep({
		additional_args = function()
			return { "--hidden", "--no-ignore" }
		end,
	})
end, { desc = "Live Grep (Faster)" })
vim.keymap.set("n", "<leader>v", builtin.buffers, { desc = "Telescope buffers" })
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

vim.keymap.set("n", "<leader>S", function()
	builtin.find_files({
		prompt_title = "Neovim Config",
		cwd = vim.fn.stdpath("config"),
	})
end, { desc = "Find Neovim Config Files" })

vim.keymap.set("n", "<leader>G", require("telescope.builtin").git_status, { desc = "Git Files" })

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"lua",
		"vim",
		"vimdoc",
		"markdown",
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

-- Map Ctrl+Z to undo
vim.api.nvim_set_keymap("n", "<C-z>", "u", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-z>", "<C-o>u", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-z>", "u", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "<C-z>", "u", { noremap = true, silent = true })

-- Ctrl+C as global copy (yanking to clipboard)
vim.api.nvim_set_keymap("n", "<C-c>", '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-c>", '<Esc>"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-c>", '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "<C-c>", '"+y', { noremap = true, silent = true })

-- Ctrl+V as global paste (pasting from clipboard)
vim.api.nvim_set_keymap("n", "<C-v>", '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-v>", '<Esc>"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-v>", '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "<C-v>", '"+p', { noremap = true, silent = true })

-- Map Ctrl+X to cut (yank and delete to clipboard)
vim.api.nvim_set_keymap("n", "<C-x>", '"+d', { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-x>", '<Esc>"+d', { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-x>", '"+d', { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "<C-x>", '"+d', { noremap = true, silent = true })

-- Map Ctrl+S to save
vim.api.nvim_set_keymap("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-s>", "<Esc>:w<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-s>", ":w<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "<C-s>", ":w<CR>", { noremap = true, silent = true })

-- Map Ctrl + A
vim.api.nvim_set_keymap("n", "<C-a>", "ggVG", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-a>", "<Esc>ggVG", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-a>", "<Esc>ggVG", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "<C-a>", "<Esc>ggVG", { noremap = true, silent = true })

-- -- Map Ctrl + / Comment out
-- vim.api.nvim_set_keymap("n", "<C-,>", "gcc", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("i", "<C-,>", "<Esc>gcc", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("v", "<C-,>", "gc", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("x", "<C-,>", "gc", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>b", "<cmd>Oil<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-t>", ":terminal<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>c", function()
	local virtual_text = require("codeium.config").options.virtual_text
	virtual_text.manual = not virtual_text.manual
	print("Codeium virtual text is now " .. (not virtual_text.manual and "enabled" or "disabled"))
end, { noremap = true, silent = true, desc = "Toggle Codeium virtual text" })

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*",
	callback = function()
		vim.cmd("FormatWrite")
	end,
})

vim.keymap.set("n", "<leader>F", '<cmd>lua require("spectre").toggle()<CR>', {
	desc = "Toggle Spectre",
})
vim.keymap.set("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
	desc = "Search current word",
})
vim.keymap.set("n", "<c-f>", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
	desc = "Search on current file",
})

vim.keymap.set("n", "<leader>g", "<cmd>Neogit cwd=%:p:h<CR>", { desc = "Neogit" })
