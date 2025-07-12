local M = {}
M.lazygit_tab = nil
M.previous_tab = nil

local api = vim.api

api.nvim_create_user_command("GitTab", function()
	local current_tab = api.nvim_get_current_tabpage()

	if M.lazygit_tab and api.nvim_tabpage_is_valid(M.lazygit_tab) then
		if current_tab == M.lazygit_tab and M.previous_tab and api.nvim_tabpage_is_valid(M.previous_tab) then
			api.nvim_set_current_tabpage(M.previous_tab)
			return
		end
		M.previous_tab = current_tab
		api.nvim_set_current_tabpage(M.lazygit_tab)
	else
		vim.cmd("tabnew")
		vim.cmd("term gitui")
		vim.cmd("startinsert")
		M.previous_tab = current_tab
		M.lazygit_tab = api.nvim_get_current_tabpage()
	end
end, {})

return M
