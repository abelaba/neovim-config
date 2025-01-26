local utils = require("alpha.utils")
local if_nil = vim.F.if_nil
local fnamemodify = vim.fn.fnamemodify
local filereadable = vim.fn.filereadable

-- Function to center text dynamically
local function center_text(lines)
	local centered_lines = {}
	local max_width = 0

	-- Find the maximum line width
	for _, line in ipairs(lines) do
		local line_width = vim.fn.strdisplaywidth(line)
		if line_width > max_width then
			max_width = line_width
		end
	end

	-- Center each line
	for _, line in ipairs(lines) do
		local line_width = vim.fn.strdisplaywidth(line)
		local padding = math.floor((max_width - line_width) / 2)
		local centered_line = string.rep(" ", padding) .. line
		table.insert(centered_lines, centered_line)
	end

	return centered_lines
end

local header_lines = require("abel.utils").header
local footer_lines = require("abel.utils").footer

local default_header = {
	type = "text",
	val = center_text(header_lines[math.random(1, #header_lines)]),
	opts = {
		hl = "Type",
		shrink_margin = true,
		position = "center",
	},
}

local default_footer = {
	type = "text",
	val = footer_lines[math.random(1, #footer_lines)],
	opts = {
		hl = "Type",
		shrink_margin = true,
		position = "center",
	},
}

local leader = "SPC"
--- @param sc string
--- @param txt string
--- @param keybind string? optional
--- @param keybind_opts table? optional
local function button(sc, txt, keybind, keybind_opts)
	local sc_ = sc:gsub("%s", ""):gsub(leader, "<leader>")

	local opts = {
		position = "left", -- Left-align buttons
		shortcut = "[" .. sc .. "] ",
		cursor = 1,
		align_shortcut = "left", -- Left-align shortcut
		hl_shortcut = { { "Operator", 0, 1 }, { "Number", 1, #sc + 1 }, { "Operator", #sc + 1, #sc + 2 } },
		shrink_margin = false,
	}
	if keybind then
		keybind_opts = if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
		opts.keymap = { "n", sc_, keybind, keybind_opts }
	end

	local function on_press()
		local key = vim.api.nvim_replace_termcodes(keybind .. "<Ignore>", true, false, true)
		vim.api.nvim_feedkeys(key, "t", false)
	end

	return {
		type = "button",
		val = txt,
		on_press = on_press,
		opts = opts,
	}
end

-- File icons configuration
local file_icons = {
	enabled = true,
	highlight = true,
	provider = "mini",
}

local function icon(fn)
	if file_icons.provider ~= "devicons" and file_icons.provider ~= "mini" then
		vim.notify(
			"Alpha: Invalid file icons provider: " .. file_icons.provider .. ", disable file icons",
			vim.log.levels.WARN
		)
		file_icons.enabled = false
		return "", ""
	end

	local ico, hl = utils.get_file_icon(file_icons.provider, fn)
	if ico == "" then
		file_icons.enabled = false
		vim.notify("Alpha: Mini icons or devicons get icon failed, disable file icons", vim.log.levels.WARN)
	end
	return ico, hl
end

local function file_button(fn, sc, short_fn, autocd)
	short_fn = if_nil(short_fn, fn)
	local ico_txt
	local fb_hl = {}
	if file_icons.enabled then
		local ico, hl = icon(fn)
		local hl_option_type = type(file_icons.highlight)
		if hl_option_type == "boolean" then
			if hl and file_icons.highlight then
				table.insert(fb_hl, { hl, 0, #ico })
			end
		end
		if hl_option_type == "string" then
			table.insert(fb_hl, { file_icons.highlight, 0, #ico })
		end
		ico_txt = ico .. "  "
	else
		ico_txt = ""
	end
	local cd_cmd = (autocd and " | cd %:p:h" or "")
	local file_button_el = button(sc, ico_txt .. short_fn, "<cmd>e " .. vim.fn.fnameescape(fn) .. cd_cmd .. " <CR>")
	local fn_start = short_fn:match(".*[/\\]")
	if fn_start ~= nil then
		table.insert(fb_hl, { "Comment", #ico_txt, #fn_start + #ico_txt })
	end
	file_button_el.opts.hl = fb_hl
	return file_button_el
end

-- MRU configuration
local default_mru_ignore = { "gitcommit" }

local mru_opts = {
	ignore = function(path, ext)
		return (string.find(path, "COMMIT_EDITMSG")) or (vim.tbl_contains(default_mru_ignore, ext))
	end,
	autocd = false,
}

--- @param start number
--- @param cwd string? optional
--- @param items_number number? optional number of items to generate, default = 10
local function mru(start, cwd, items_number, opts)
	opts = opts or mru_opts
	items_number = if_nil(items_number, 10)
	local oldfiles = {}
	for _, v in pairs(vim.v.oldfiles) do
		if #oldfiles == items_number then
			break
		end
		local cwd_cond
		if not cwd then
			cwd_cond = true
		else
			cwd_cond = vim.startswith(v, cwd)
		end
		local ignore = (opts.ignore and opts.ignore(v, utils.get_extension(v))) or false
		if (filereadable(v) == 1) and cwd_cond and not ignore then
			oldfiles[#oldfiles + 1] = v
		end
	end

	local tbl = {}
	for i, fn in ipairs(oldfiles) do
		local short_fn
		if cwd then
			short_fn = fnamemodify(fn, ":.")
		else
			short_fn = fnamemodify(fn, ":~")
		end
		local file_button_el = file_button(fn, tostring(i + start - 1), short_fn, opts.autocd)
		tbl[i] = file_button_el
	end
	return {
		type = "group",
		val = tbl,
		opts = {
			position = "left", -- Left-align MRU items
		},
	}
end

-- MRU Project Folders

local function get_mru_projects(start, items_number)
	-- Set default for start if it's nil
	start = start or 1 -- Default start is 100 if not passed
	items_number = if_nil(items_number, 10)

	-- Create a table to store unique project directories
	local project_dirs = {}
	for _, v in ipairs(vim.v.oldfiles) do
		if #project_dirs == items_number then
			break
		end

		local project_dir = vim.fn.fnamemodify(v, ":p:h") -- Get the directory of the file
		if filereadable(v) == 1 and not vim.tbl_contains(project_dirs, project_dir) then
			table.insert(project_dirs, project_dir)
		end
	end

	-- Create buttons for the projects
	local tbl = {}
	for i, project_dir in ipairs(project_dirs) do
		local short_dir = vim.fn.fnamemodify(project_dir, ":~") -- Display relative path
		local project_button = file_button(project_dir, tostring(i + start - 1), short_dir, false) -- Create a button for the project
		tbl[i] = project_button
	end

	return tbl
end

-- Sections
local section = {
	header = default_header,
	top_buttons = {
		type = "group",
		val = {
			button("e", "New file", "<cmd>ene <CR>"),
		},
	},
	-- note about MRU: currently this is a function,
	-- since that means we can get a fresh mru
	-- whenever there is a DirChanged. this is *really*
	-- inefficient on redraws, since mru does a lot of I/O.
	-- should probably be cached, or maybe figure out a way
	-- to make it a reference to something mutable
	-- and only mutate that thing on DirChanged
	mru_projects = {
		type = "group",
		val = {
			{ type = "padding", val = 1 },
			{ type = "text", val = "MRU Projects", opts = { hl = "SpecialComment", position = "left" } }, -- Left-align title
			{ type = "padding", val = 1 },
			{
				type = "group",
				val = function()
					return get_mru_projects(1, 5)
				end,
				opts = {
					position = "left", -- Left-align MRU projects section
				},
			},
		},
	},
	mru = {
		type = "group",
		val = {
			{ type = "padding", val = 1 },
			{ type = "text", val = "MRU", opts = { hl = "SpecialComment" } },
			{ type = "padding", val = 1 },
			{
				type = "group",
				val = function()
					return { mru(10) }
				end,
			},
		},
	},
	mru_cwd = {
		type = "group",
	},
	footer = default_footer,
}

-- Layout
local config = {
	layout = {
		{ type = "padding", val = 2 }, -- Add padding to center vertically
		section.header,
		{ type = "padding", val = 2 },
		section.top_buttons,
		section.mru_projects,
		section.mru,
		{ type = "padding", val = 2 },
		section.bottom_buttons,
		section.footer,
		{ type = "padding", val = 2 }, -- Add padding to center vertically
	},
	opts = {
		margin = 5, -- Increase margin for better centering
		redraw_on_resize = false,
	},
}

return {
	icon = icon,
	button = button,
	file_button = file_button,
	mru = mru,
	mru_opts = mru_opts,
	section = section,
	config = config,
	file_icons = file_icons,
	leader = leader,
}
