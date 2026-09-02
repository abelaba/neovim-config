-- Statusline component showing how many coding agents are running in the
-- current working directory. Currently detects Claude Code: its processes
-- carry the title "claude" (ps shows the rewritten title, so lsof -c cannot
-- be used: the executable is named after the CLI version), and bg-* helpers
-- from the daemon spare pool are excluded.
local M = { count = 0 }

local FIND_AGENTS = [[
pids=$(ps -axo pid=,command= | awk '$2 == "claude" && $3 !~ /^bg-/ {print $1}' | paste -sd, -)
[ -n "$pids" ] && lsof -a -d cwd -p "$pids" -Fn 2>/dev/null
exit 0
]]

function M.refresh()
	local cwd = vim.fn.getcwd()
	vim.system({ "sh", "-c", FIND_AGENTS }, { text = true }, function(out)
		local count = 0
		for path in (out.stdout or ""):gmatch("\nn([^\n]+)") do
			if path == cwd then
				count = count + 1
			end
		end
		if count ~= M.count then
			M.count = count
			vim.schedule(function()
				vim.cmd.redrawstatus()
			end)
		end
	end)
end

-- For use in 'statusline' via %{v:lua...}; empty when no agents are running
function M.component()
	if M.count == 0 then
		return ""
	end
	return "󱚝 " .. M.count
end

function M.setup()
	if M.timer then
		return
	end
	-- mirror the default statusline, with the agent count on the right
	vim.o.statusline = "%f %h%w%m%r%=%{v:lua.require'abel.utils.agent_status'.component()} %-14.(%l,%c%V%) %P"

	M.timer = (vim.uv or vim.loop).new_timer()
	M.timer:start(0, 5000, vim.schedule_wrap(M.refresh))
	vim.api.nvim_create_autocmd({ "FocusGained", "TermLeave", "DirChanged" }, {
		callback = M.refresh,
	})
end

return M
