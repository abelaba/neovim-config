-- Agent-agnostic actions for working with a coding agent (add context,
-- send selections, manage diffs). Each action is dispatched to the first
-- backend in M.backend_order that is available and implements it. Add a
-- backend by inserting into M.backends with an available() function and
-- any subset of the action functions.
local M = {}

local function tree_node_path()
	if vim.bo.filetype == "neo-tree" then
		local ok, node = pcall(function()
			return require("neo-tree.sources.manager").get_state("filesystem").tree:get_node()
		end)
		if ok and node then
			return node.path or node:get_id()
		end
	end
	return nil
end

-- Capture the current visual selection as { rel, first, last, lines },
-- exiting visual mode. Returns nil if not in visual mode.
local function capture_selection()
	local mode = vim.fn.mode()
	if mode ~= "v" and mode ~= "V" and mode ~= "\22" then
		return nil
	end
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
	local first, last = vim.fn.line("'<"), vim.fn.line("'>")
	return {
		rel = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":."),
		first = first,
		last = last,
		lines = vim.api.nvim_buf_get_lines(0, first - 1, last, false),
	}
end

M.backends = {
	claudecode = {
		available = function()
			local ok, lazy_config = pcall(require, "lazy.core.config")
			return ok and lazy_config.plugins["claudecode.nvim"] ~= nil
		end,
		add_buffer = function()
			vim.cmd("ClaudeCodeAdd %")
		end,
		send_selection = function()
			vim.cmd("ClaudeCodeSend")
		end,
		add_tree_file = function()
			vim.cmd("ClaudeCodeTreeAdd")
		end,
		accept_diff = function()
			vim.cmd("ClaudeCodeDiffAccept")
		end,
		deny_diff = function()
			vim.cmd("ClaudeCodeDiffDeny")
		end,
	},
	-- Universal fallback: put a pasteable reference or snippet on the system
	-- clipboard for any agent CLI (codex, aider, opencode, ...).
	clipboard = {
		available = function()
			return true
		end,
		add_buffer = function()
			local rel = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
			vim.fn.setreg("+", "@" .. rel)
			vim.notify("Copied @" .. rel .. " to clipboard")
		end,
		send_selection = function()
			local sel = capture_selection()
			if not sel then
				vim.notify("No visual selection", vim.log.levels.WARN)
				return
			end
			local text = ("%s:%d-%d\n```\n%s\n```"):format(sel.rel, sel.first, sel.last, table.concat(sel.lines, "\n"))
			vim.fn.setreg("+", text)
			vim.notify(("Copied %s:%d-%d to clipboard"):format(sel.rel, sel.first, sel.last))
		end,
		add_tree_file = function()
			local path = tree_node_path()
			if not path then
				vim.notify("No file selected in tree", vim.log.levels.WARN)
				return
			end
			local rel = vim.fn.fnamemodify(path, ":.")
			vim.fn.setreg("+", "@" .. rel)
			vim.notify("Copied @" .. rel .. " to clipboard")
		end,
		-- no accept_diff/deny_diff: that workflow is agent-specific
	},
}

M.backend_order = { "clipboard", "claudecode" }

local function dispatch(action)
	return function()
		for _, name in ipairs(M.backend_order) do
			local backend = M.backends[name]
			if backend.available() and backend[action] then
				return backend[action]()
			end
		end
		vim.notify("No available agent backend supports: " .. action, vim.log.levels.WARN)
	end
end

M.add_buffer = dispatch("add_buffer")
M.send_selection = dispatch("send_selection")
M.add_tree_file = dispatch("add_tree_file")
M.accept_diff = dispatch("accept_diff")
M.deny_diff = dispatch("deny_diff")

return M
