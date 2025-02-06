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
vim.opt.fileformats = "unix,dos,mac"
vim.opt.rtp:prepend(lazypath)
vim.wo.relativenumber = true
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
		{
			"folke/noice.nvim",
			event = "VeryLazy",
			dependencies = {
				"MunifTanjim/nui.nvim",
			},
		},
		{
			"NeogitOrg/neogit",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"sindrets/diffview.nvim",
				"nvim-telescope/telescope.nvim",
			},
			config = true,
		},
		{
			"nvim-telescope/telescope.nvim",
			tag = "0.1.8",
			dependencies = { "nvim-lua/plenary.nvim" },
		},
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
		{
			"goolord/alpha-nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				local startify = require("abel.dashboard-config")
				require("alpha").setup(startify.config)
			end,
		},
		{ "lewis6991/gitsigns.nvim", name = "gitsigns" },
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
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
		{
			"kawre/leetcode.nvim",
			build = ":TSUpdate html", -- if you have nvim-treesitter installed
			dependencies = {
				"nvim-telescope/telescope.nvim",
				"nvim-lua/plenary.nvim",
				"MunifTanjim/nui.nvim",
			},
			opts = {
				arg = "l",
				lang = "python3",
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
			"Exafunction/codeium.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"hrsh7th/nvim-cmp",
			},
		},
		{
			"hrsh7th/nvim-cmp",
			dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
		},
		{ "mhartington/formatter.nvim" },
		{
			"nvim-flutter/flutter-tools.nvim",
			lazy = false,
			dependencies = {
				"nvim-lua/plenary.nvim",
				"stevearc/dressing.nvim",
			},
			config = true,
		},
		-- { "akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons" },
		{ "nvim-pack/nvim-spectre" },
		{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "vscode" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})

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

require("flutter-tools").setup({})
-- require("bufferline").setup({})

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

vim.keymap.set("n", "<leader>b", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
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
