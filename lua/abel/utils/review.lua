-- Collect review comments on lines or files and send them to a coding agent.
-- Collection is agent-agnostic; delivery goes through "sinks". The first
-- available sink in M.sink_order is used, or pass an explicit sink name to
-- send_review(). Add a sink by inserting into M.sinks: it needs available()
-- and send(path, comments, lines) -> ok, message.
local M = {}

M.comments = {}

local function review_path()
	local git_root = vim.fs.root(0, ".git") or vim.fn.getcwd()
	if vim.fn.isdirectory(git_root .. "/.git") == 1 then
		-- inside .git: within the project (agents can read it without leaving
		-- the workspace), but never tracked or picked up by other tools
		return git_root .. "/.git/agent-review.md"
	end
	return vim.fn.stdpath("cache") .. "/agent-review.md"
end

local function compose()
	local lines = {
		"# Review comments",
		"",
		"Address each comment below. Locations are file:start-end line references.",
		"",
	}
	for i, c in ipairs(M.comments) do
		local loc = c.first and ("%s lines %d-%d"):format(c.rel, c.first, c.last) or c.rel
		table.insert(lines, ("## %d. %s"):format(i, loc))
		if c.snippet then
			table.insert(lines, "```")
			vim.list_extend(lines, c.snippet)
			table.insert(lines, "```")
		end
		table.insert(lines, "")
		table.insert(lines, c.text)
		table.insert(lines, "")
	end
	return lines
end

M.sinks = {
	-- Claude Code via claudecode.nvim: at-mentions the review file and each
	-- commented range into Claude's prompt input.
	claudecode = {
		available = function()
			local ok, lazy_config = pcall(require, "lazy.core.config")
			return ok and lazy_config.plugins["claudecode.nvim"] ~= nil
		end,
		send = function(path, comments)
			local cc = require("claudecode")
			local ok, err = cc.send_at_mention(path, nil, nil, "review")
			if not ok then
				return false, err
			end
			for _, c in ipairs(comments) do
				if c.first then
					cc.send_at_mention(c.file, c.first - 1, c.last - 1, "review")
				end
			end
			return true, "at-mentioned to Claude Code; type your instruction in its terminal"
		end,
	},
	-- Universal fallback: the full review text goes to the system clipboard,
	-- ready to paste into any agent CLI (codex, aider, opencode, ...).
	clipboard = {
		available = function()
			return true
		end,
		send = function(_, _, lines)
			vim.fn.setreg("+", table.concat(lines, "\n"))
			return true, "copied to clipboard; paste into your agent"
		end,
	},
}

M.sink_order = { "claudecode", "clipboard" }

-- Add a comment for the visual selection (line range) or, in normal mode,
-- for the whole current file.
function M.add_comment()
	local file = vim.api.nvim_buf_get_name(0)
	if vim.fn.filereadable(file) == 0 then
		vim.notify("Buffer is not a file on disk", vim.log.levels.WARN)
		return
	end

	local first, last
	local mode = vim.fn.mode()
	if mode == "v" or mode == "V" or mode == "\22" then
		-- exit visual mode synchronously ("x" flag) so the '< and '> marks
		-- are set and no visual state leaks into later mappings
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
		first, last = vim.fn.line("'<"), vim.fn.line("'>")
	end

	local rel = vim.fn.fnamemodify(file, ":.")
	local loc = first and ("%s:%d-%d"):format(rel, first, last) or rel
	vim.ui.input({ prompt = "Comment on " .. loc .. ": " }, function(text)
		if not text or text == "" then
			return
		end
		local snippet = first and vim.api.nvim_buf_get_lines(0, first - 1, last, false) or nil
		table.insert(M.comments, { file = file, rel = rel, first = first, last = last, text = text, snippet = snippet })
		vim.notify(("Review comment %d added (%s)"):format(#M.comments, loc))
	end)
end

-- Write all comments to the review file and deliver them through the given
-- sink, or the first available one in M.sink_order.
function M.send_review(sink_name)
	if #M.comments == 0 then
		vim.notify("No review comments to send", vim.log.levels.WARN)
		return
	end

	local sink
	if sink_name then
		sink = M.sinks[sink_name]
		if not sink then
			vim.notify("Unknown review sink: " .. sink_name, vim.log.levels.ERROR)
			return
		end
	else
		for _, name in ipairs(M.sink_order) do
			if M.sinks[name].available() then
				sink, sink_name = M.sinks[name], name
				break
			end
		end
	end

	local lines = compose()
	local path = review_path()
	vim.fn.writefile(lines, path)

	local ok, msg = sink.send(path, M.comments, lines)
	if not ok then
		vim.notify(("Failed to send review via %s: %s"):format(sink_name, msg or "unknown error"), vim.log.levels.ERROR)
		return
	end

	vim.notify(("Sent %d review comment(s) via %s: %s"):format(#M.comments, sink_name, msg))
	M.comments = {}
end

-- Show pending comments in the quickfix list.
function M.show_review()
	if #M.comments == 0 then
		vim.notify("No review comments", vim.log.levels.WARN)
		return
	end
	local items = {}
	for _, c in ipairs(M.comments) do
		table.insert(items, { filename = c.file, lnum = c.first or 1, text = c.text })
	end
	vim.fn.setqflist({}, " ", { title = "Review comments", items = items })
	vim.cmd("copen")
end

function M.clear_review()
	M.comments = {}
	vim.notify("Cleared review comments")
end

return M
