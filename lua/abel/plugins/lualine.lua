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

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "BufReadPost",
	config = function()
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
				},
				lualine_c = {
					{
						"filename",
						path = 1,
						symbols = { modified = "*", readonly = "x", unnamed = "[No Name]" },
					},
					{ "filetype", icon_only = true },
				},

				lualine_x = {
					{
						"diff",
						symbols = { added = " ", modified = " ", removed = " " },
					},
				},
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
					-- function()
					-- 	return get_wiggly_emoji()
					-- end,
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
			extensions = { "nvim-tree" },
		})
	end,
}
