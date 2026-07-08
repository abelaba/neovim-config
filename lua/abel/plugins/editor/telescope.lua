local build_cmd ---@type string?
for _, cmd in ipairs({ "make", "cmake", "gmake" }) do
	if vim.fn.executable(cmd) == 1 then
		build_cmd = cmd
		break
	end
end

return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		version = false, -- telescope did only one release, so use HEAD for now
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = (build_cmd ~= "cmake") and "make"
					or "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
				enabled = build_cmd ~= nil,
			},
			{
				"debugloop/telescope-undo.nvim",
			},
		},
		keys = function()
			local builtin = require("telescope.builtin")
			return {
				{ "<leader>,", builtin.buffers, desc = "Switch Buffer" },
				{ "<leader>/", builtin.live_grep, desc = "Grep (Root Dir)" },
				{ "<leader>:", builtin.command_history, desc = "Command History" },
				{ "<leader><space>", builtin.oldfiles, desc = "Find Files (Root Dir)" },
				{
					"<leader>fb",
					function()
						builtin.buffers({ sort_mru = true, sort_lastused = true, ignore_current_buffer = true })
					end,
					desc = "Buffers",
				},
				{
					"<leader>fc",
					function()
						builtin.find_files({ prompt_title = "Find Config File", cwd = vim.fn.stdpath("config") })
					end,
					desc = "Find Config File",
				},
				{ "<leader>ff", builtin.find_files, desc = "Find Files (Root Dir)" },
				{
					"<leader>fF",
					function()
						builtin.find_files({ cwd = vim.fn.getcwd() })
					end,
					desc = "Find Files (cwd)",
				},
				{ "<leader>fg", builtin.git_files, desc = "Find Files (git-files)" },
				{
					"<leader>fR",
					function()
						builtin.oldfiles({ cwd = vim.fn.getcwd() })
					end,
					desc = "Recent Files (cwd)",
				},

				-- Git
				{ "<leader>gc", builtin.git_commits, desc = "Git Commits" },
				{ "<leader>gs", builtin.git_status, desc = "Git Status" },
				{ "<leader>gb", builtin.git_branches, desc = "Git Branch" },

				-- Search
				{ '<leader>s"', builtin.registers, desc = "Registers" },
				{ "<leader>sa", builtin.autocommands, desc = "Autocommands" },
				{ "<leader>sb", builtin.current_buffer_fuzzy_find, desc = "Buffer Search" },
				{ "<leader>sc", builtin.command_history, desc = "Command History" },
				{ "<leader>sC", builtin.commands, desc = "Commands" },
				{
					"<leader>sd",
					function()
						builtin.diagnostics({ bufnr = 0 })
					end,
					desc = "Document Diagnostics",
				},
				{ "<leader>sD", builtin.diagnostics, desc = "Workspace Diagnostics" },
				{ "<leader>sg", builtin.live_grep, desc = "Grep (Root Dir)" },
				{
					"<leader>sG",
					function()
						builtin.live_grep({ cwd = vim.fn.getcwd() })
					end,
					desc = "Grep (cwd)",
				},
				{ "<leader>sh", builtin.help_tags, desc = "Help Pages" },
				{ "<leader>sH", builtin.highlights, desc = "Highlight Groups" },
				{ "<leader>sj", builtin.jumplist, desc = "Jumplist" },
				{ "<leader>sk", builtin.keymaps, desc = "Keymaps" },
				{ "<leader>sl", builtin.loclist, desc = "Location List" },
				{ "<leader>sm", builtin.marks, desc = "Marks" },
				{ "<leader>sM", builtin.man_pages, desc = "Man Pages" },
				{ "<leader>so", builtin.vim_options, desc = "Vim Options" },
				{ "<leader>sq", builtin.quickfix, desc = "Quickfix List" },
				{ "<leader>sR", builtin.resume, desc = "Resume Last Picker" },

				-- Grep Word / Selection
				{
					"<leader>sw",
					function()
						builtin.grep_string({ word_match = "-w" })
					end,
					desc = "Word (Root Dir)",
				},
				{
					"<leader>sW",
					function()
						builtin.grep_string({ cwd = vim.fn.getcwd(), word_match = "-w" })
					end,
					desc = "Word (cwd)",
				},
				{
					"<leader>sw",
					function()
						builtin.grep_string()
					end,
					mode = "v",
					desc = "Selection (Root Dir)",
				},
				{
					"<leader>sW",
					function()
						builtin.grep_string({ cwd = vim.fn.getcwd() })
					end,
					mode = "v",
					desc = "Selection (cwd)",
				},

				-- Colorscheme
				{
					"<leader>uC",
					function()
						builtin.colorscheme({ enable_preview = true })
					end,
					desc = "Colorscheme with Preview",
				},

				-- LSP Symbols
				{
					"<leader>ss",
					function()
						builtin.lsp_document_symbols({
							symbols = { "Function", "Method", "Class", "Interface", "Module", "Struct" },
						})
					end,
					desc = "Goto Symbol",
				},
				{
					"<leader>sS",
					function()
						builtin.lsp_dynamic_workspace_symbols({
							symbols = { "Function", "Method", "Class", "Interface", "Module", "Struct" },
						})
					end,
					desc = "Goto Symbol (Workspace)",
				},
			}
		end,
	},
}
