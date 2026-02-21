local function open_gitui_float()
	-- Create buffer
	local buf = vim.api.nvim_create_buf(false, true)

	-- Get editor size
	local width = math.floor(vim.o.columns * 0.9)
	local height = math.floor(vim.o.lines * 0.9)

	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	-- Window options
	local opts = {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	}

	-- Open floating window
	local win = vim.api.nvim_open_win(buf, true, opts)

	-- Start terminal with gitui
	vim.fn.jobstart("gitui", {
		term = true,
		on_exit = function()
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end
		end,
	})

	-- Enter insert mode automatically
	vim.cmd("startinsert")
end

vim.api.nvim_create_user_command("GitTab", open_gitui_float, {})
