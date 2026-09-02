-- Observability for your own editing: collects aggregate usage signals and
-- renders an agent-ready report (:ObservabilityReport) about (1) coding
-- habits and (2) how efficiently you drive Neovim.
--
-- Privacy: no text content is ever recorded. Normal/visual/operator-pending
-- keys are counted by key name; insert mode contributes only a total count;
-- ex-commands are recorded by their first word only.
--
-- Data: one JSON file per day in stdpath("data")/observability/. Counters
-- accumulate in memory and are flushed on exit and every 5 minutes.
local M = {}

local uv = vim.uv or vim.loop

local dir = vim.fn.stdpath("data") .. "/observability"

local function new_counters()
	return {
		sessions = 1,
		keys = {},          -- normal/visual/operator keys -> count
		insert_keys = 0,    -- total only, never which
		arrows = 0,
		motion_runs = { count = 0, total_len = 0, max = 0 }, -- hjkl runs >= threshold
		commands = {},      -- command head -> count
		saves = {},         -- ft -> { count, with_errors, errors, warnings }
		mode_seconds = {},  -- mode -> seconds
	}
end

local c = new_counters()

-- ---------------------------------------------------------------- collection

local MOTIONS = { h = true, j = true, k = true, l = true }
local RUN_THRESHOLD = 5
local run_key, run_len = nil, 0

local function track_motion_run(key)
	if key == run_key then
		run_len = run_len + 1
		return
	end
	if run_key and run_len >= RUN_THRESHOLD then
		local r = c.motion_runs
		r.count = r.count + 1
		r.total_len = r.total_len + run_len
		r.max = math.max(r.max, run_len)
	end
	run_key = MOTIONS[key] and key or nil
	run_len = 1
end

local function on_key(_, typed)
	if not typed or typed == "" then
		return
	end
	local mode = vim.fn.mode()
	if mode == "i" or mode == "t" then
		if mode == "i" then
			c.insert_keys = c.insert_keys + 1
		end
		return
	end
	if mode ~= "n" and mode ~= "no" and not mode:match("^[vV\22]") then
		return
	end
	local key = vim.fn.keytrans(typed)
	c.keys[key] = (c.keys[key] or 0) + 1
	if key:match("^<%a*Up>$") or key:match("^<%a*Down>$") or key:match("^<%a*Left>$") or key:match("^<%a*Right>$") then
		c.arrows = c.arrows + 1
	end
	track_motion_run(key)
end

local function on_cmdline_leave()
	if vim.fn.getcmdtype() ~= ":" then
		return
	end
	local head = vim.fn.getcmdline():match("^%s*([%w!/]+)")
	if head then
		c.commands[head] = (c.commands[head] or 0) + 1
	end
end

local function on_save(args)
	local ft = vim.bo[args.buf].filetype
	if ft == "" then
		return
	end
	local s = c.saves[ft] or { count = 0, with_errors = 0, errors = 0, warnings = 0 }
	local diag = vim.diagnostic.count(args.buf)
	local errors = diag[vim.diagnostic.severity.ERROR] or 0
	s.count = s.count + 1
	s.errors = s.errors + errors
	s.warnings = s.warnings + (diag[vim.diagnostic.severity.WARN] or 0)
	s.with_errors = s.with_errors + (errors > 0 and 1 or 0)
	c.saves[ft] = s
end

local mode_since = uv.hrtime()
local last_mode = "n"

local function on_mode_changed()
	local now = uv.hrtime()
	local mode = last_mode
	c.mode_seconds[mode] = (c.mode_seconds[mode] or 0) + (now - mode_since) / 1e9
	mode_since = now
	last_mode = vim.fn.mode()
end

-- --------------------------------------------------------------- persistence

local function merge(into, from)
	for k, v in pairs(from) do
		if type(v) == "number" then
			if k == "max" then -- not additive
				into[k] = math.max(into[k] or 0, v)
			else
				into[k] = (into[k] or 0) + v
			end
		elseif type(v) == "table" then
			into[k] = into[k] or {}
			merge(into[k], v)
		end
	end
end

local function today_file()
	return dir .. "/" .. os.date("%Y-%m-%d") .. ".json"
end

local function flush()
	on_mode_changed() -- bank the current mode's time
	track_motion_run("") -- bank a pending motion run
	vim.fn.mkdir(dir, "p")
	local path = today_file()
	local on_disk = {}
	if vim.fn.filereadable(path) == 1 then
		local ok, decoded = pcall(vim.json.decode, table.concat(vim.fn.readfile(path), "\n"))
		if ok then
			on_disk = decoded
		end
	end
	merge(on_disk, c)
	vim.fn.writefile({ vim.json.encode(on_disk) }, path)
	c = new_counters()
	c.sessions = 0 -- this session is already counted
end

-- -------------------------------------------------------------------- report

local function load_all()
	local total, days = {}, 0
	for _, path in ipairs(vim.fn.glob(dir .. "/*.json", false, true)) do
		local ok, decoded = pcall(vim.json.decode, table.concat(vim.fn.readfile(path), "\n"))
		if ok then
			merge(total, decoded)
			days = days + 1
		end
	end
	return total, days
end

local function top(counts, n)
	local entries = {}
	for k, v in pairs(counts or {}) do
		table.insert(entries, { k, v })
	end
	table.sort(entries, function(a, b)
		return a[2] > b[2]
	end)
	return vim.list_slice(entries, 1, n)
end

function M.report()
	flush()
	local t, days = load_all()
	local lines = {
		"# Neovim usage report",
		"",
		"Generated " .. os.date("%Y-%m-%d %H:%M") .. " covering " .. days .. " day(s), "
			.. (t.sessions or 0) .. " session(s).",
		"",
		"Prompt for an agent reviewing this report: based on the aggregate usage",
		"data below, suggest concretely (1) how I can improve my coding habits and",
		"(2) how I can drive Neovim more efficiently (motions, text objects,",
		"commands worth mapping, unused features). Data is aggregate counts only.",
		"",
		"## Editor interaction",
		"",
		"### Top normal/visual mode keys",
	}
	for _, e in ipairs(top(t.keys, 25)) do
		table.insert(lines, ("- `%s`: %d"):format(e[1], e[2]))
	end
	local runs = t.motion_runs or {}
	vim.list_extend(lines, {
		"",
		"### Inefficiency signals",
		("- hjkl runs of >= %d repeats: %d (avg length %.1f, longest %d) — candidates for relative jumps, `f`/`t`, or search"):format(
			RUN_THRESHOLD,
			runs.count or 0,
			(runs.count or 0) > 0 and (runs.total_len or 0) / runs.count or 0,
			runs.max or 0
		),
		("- arrow key presses: %d"):format(t.arrows or 0),
		("- insert-mode keystrokes (total): %d"):format(t.insert_keys or 0),
		"",
		"### Mode time (seconds)",
	})
	for _, e in ipairs(top(t.mode_seconds, 8)) do
		table.insert(lines, ("- `%s`: %d"):format(e[1], math.floor(e[2])))
	end
	vim.list_extend(lines, { "", "### Top ex-commands (first word only)" })
	for _, e in ipairs(top(t.commands, 15)) do
		table.insert(lines, ("- `:%s`: %d"):format(e[1], e[2]))
	end
	vim.list_extend(lines, { "", "## Coding habits", "", "### Saves per filetype (diagnostics at save time)" })
	for ft, s in pairs(t.saves or {}) do
		table.insert(
			lines,
			("- %s: %d saves, %d with errors present (%.0f%%), %d errors / %d warnings total"):format(
				ft, s.count, s.with_errors, s.count > 0 and 100 * s.with_errors / s.count or 0, s.errors, s.warnings
			)
		)
	end
	local undo = (t.keys or {}).u or 0
	vim.list_extend(lines, {
		"",
		("### Churn: %d undos across %d day(s)"):format(undo, days),
	})

	local path = dir .. "/report.md"
	vim.fn.writefile(lines, path)
	vim.cmd("split " .. vim.fn.fnameescape(path))
	vim.notify("Report written to " .. path .. " — send it to an agent with <leader>ab")
end

-- --------------------------------------------------------------------- setup

local ns = vim.api.nvim_create_namespace("abel_observability")
local enabled = false

function M.enable()
	if enabled then
		return
	end
	enabled = true
	mode_since = uv.hrtime()
	last_mode = vim.fn.mode()
	vim.on_key(on_key, ns)
	local group = vim.api.nvim_create_augroup("abel_observability", { clear = true })
	vim.api.nvim_create_autocmd("CmdlineLeave", { group = group, callback = on_cmdline_leave })
	vim.api.nvim_create_autocmd("BufWritePost", { group = group, callback = on_save })
	vim.api.nvim_create_autocmd("ModeChanged", { group = group, callback = on_mode_changed })
	vim.api.nvim_create_autocmd("VimLeavePre", { group = group, callback = flush })
	M.timer = M.timer or uv.new_timer()
	M.timer:start(300000, 300000, vim.schedule_wrap(flush))
end

function M.disable()
	if not enabled then
		return
	end
	enabled = false
	flush()
	vim.on_key(nil, ns)
	vim.api.nvim_del_augroup_by_name("abel_observability")
	M.timer:stop()
	vim.notify("Observability disabled for this session")
end

function M.setup()
	M.enable()
	vim.api.nvim_create_user_command("ObservabilityReport", M.report, {})
	vim.api.nvim_create_user_command("ObservabilityToggle", function()
		if enabled then
			M.disable()
		else
			M.enable()
		end
	end, {})
end

return M
