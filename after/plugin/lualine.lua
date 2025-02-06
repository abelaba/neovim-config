-- Bubbles config for lualine with enhanced visuals
-- Author: lokesh-krishna (modified with additional enhancements)
-- MIT license, see LICENSE for more details.

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
		section_separators = { left = "", right = "" },
		icons_enabled = true,
	},
	sections = {
		lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
		lualine_b = {
			{ "branch", icon = "" },
		},
		lualine_c = {
			{ "filename", path = 1, symbols = { modified = " ●", readonly = " ", unnamed = "[No Name]" } },
		},
		lualine_x = { "encoding", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { { "location", separator = { right = "" } } },
	},
	inactive_sections = {
		lualine_a = { { "filename", path = 1 } },
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = { "location" },
	},
	tabline = {},
	extensions = {},
})
