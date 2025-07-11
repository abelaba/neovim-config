local h_pct = 0.95
local w_pct = 0.95
local w_limit = 75
local standard_setup = {
	borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
	preview = { hide_on_startup = true },
	layout_strategy = "vertical",
	layout_config = {
		vertical = {
			mirror = true,
			prompt_position = "top",
			width = function(_, cols, _)
				return math.min(math.floor(w_pct * cols), w_limit)
			end,
			height = function(_, _, rows)
				return math.floor(rows * h_pct)
			end,
			preview_cutoff = 10,
			preview_height = 0.4,
		},
	},
}
local fullscreen_setup = {
	borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
	preview = { hide_on_startup = true },
	layout_strategy = "vertical",
	layout_config = {
		flex = { flip_columns = 100 },
		horizontal = {
			mirror = false,
			prompt_position = "top",
			width = function(_, cols, _)
				return math.floor(cols * w_pct)
			end,
			height = function(_, _, rows)
				return math.floor(rows * h_pct)
			end,
			preview_cutoff = 10,
			preview_width = 0.5,
		},
		vertical = {
			mirror = true,
			prompt_position = "top",
			width = function(_, cols, _)
				return math.floor(cols * w_pct)
			end,
			height = function(_, _, rows)
				return math.floor(rows * h_pct)
			end,
			preview_cutoff = 11,
			preview_height = 0.65,
		},
	},
}

require("telescope").setup({
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
		undo = {
			-- telescope-undo.nvim config, see below
		},
	},
	defaults = vim.tbl_deep_extend("force", fullscreen_setup, {
		mappings = {
			i = {
				["<C-p>"] = require("telescope.actions.layout").toggle_preview,
			},
			n = {
				["<C-p>"] = require("telescope.actions.layout").toggle_preview,
			},
		},
	}),
})

require("telescope").load_extension("fzf")
require("telescope").load_extension("undo")
