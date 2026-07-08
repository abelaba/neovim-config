return {
	"sindrets/diffview.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
	opts = {
		enhanced_diff_hl = true,
		view = {
			default = { winbar_info = true },
		},
	},
	keys = {
		{
			"<leader>gr",
			function()
				if require("diffview.lib").get_current_view() then
					vim.cmd("DiffviewClose")
				else
					vim.cmd("DiffviewOpen")
				end
			end,
			desc = "Toggle review mode (all edited files)",
		},
		{ "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "History of current file" },
		{ "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "Repo history" },
	},
}
