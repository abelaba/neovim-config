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
