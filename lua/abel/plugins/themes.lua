return {
	{
		"Mofiqul/vscode.nvim",
		config = function()
			local c = require("vscode.colors").get_colors()
			local transparency = not vim.g.neovide
			require("vscode").setup({
				transparent = transparency,
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
		end,
	},
}
