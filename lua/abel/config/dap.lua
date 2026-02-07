local dap = require("dap")
local dapui = require("dapui")
-- local dap_python = require("dap-python")

dapui.setup()
require("nvim-dap-virtual-text").setup({
	commented = true, -- Show virtual text alongside comment
})

-- dap_python.setup("python3")

vim.fn.sign_define("DapBreakpoint", {
	text = "",
	texthl = "DiagnosticSignError",
	linehl = "",
	numhl = "",
})

vim.fn.sign_define("DapBreakpointRejected", {
	text = "", -- or "❌"
	texthl = "DiagnosticSignError",
	linehl = "",
	numhl = "",
})

vim.fn.sign_define("DapStopped", {
	text = "", -- or "→"
	texthl = "DiagnosticSignWarn",
	linehl = "Visual",
	numhl = "DiagnosticSignWarn",
})

-- dap.listeners.before.attach.dapui_config = function()
-- 	pcall(vim.cmd, "Neotree close")
-- 	dapui.open()
-- end
-- dap.listeners.before.launch.dapui_config = function()
-- 	pcall(vim.cmd, "Neotree close")
-- 	dapui.open()
-- end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end

-- -- Automatically open/close DAP UI
dap.listeners.after.event_initialized["dapui_config"] = function()
	pcall(vim.cmd, "Neotree close")
	dapui.open()
end


require("dap-python").setup(vim.fn.getcwd() .. "/.venv/bin/python")
dap.configurations.python = {
	{
		type = "python",
		request = "launch",
		name = "Click: run slidev",
		program = "run_script.py",
		justMyCode = false,
		console = "integratedTerminal",
	},
}

require("dapui").setup({
	layouts = {
		{
			elements = {
				{ id = "scopes",      size = 0.25 },
				{ id = "breakpoints", size = 0.25 },
				{ id = "stacks",      size = 0.25 },
				{ id = "watches",     size = 0.25 },
			},
			size = 40, -- columns
			position = "left",
		},
		{
			elements = {
				"repl",
				"console",
			},
			size = 10, -- lines
			position = "bottom",
		},
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "neo-tree",
	callback = function()
		dapui.close()
	end,
})


-- Ensure nvim-dap is installed
local dap_ok, dap = pcall(require, 'dap')
if not dap_ok then
	return
end

-- ===============================
-- Keymaps for DAP
-- ===============================
-- Only active when a buffer is in debug mode
local function set_dap_keymaps()
	local opts = { noremap = true, silent = true, buffer = 0 }

	-- Stepping
	vim.keymap.set('n', 'n', dap.step_over, opts) -- step over
	vim.keymap.set('n', 'i', dap.step_into, opts) -- step into
	vim.keymap.set('n', 'o', dap.step_out, opts) -- step out
	vim.keymap.set('n', 'c', dap.continue, opts) -- continue

	-- Breakpoints
	vim.keymap.set('n', 'b', dap.toggle_breakpoint, opts) -- toggle breakpoint
	vim.keymap.set('n', 'B', function()                  -- conditional breakpoint
		dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
	end, opts)

	-- REPL and hover
	vim.keymap.set('n', 'r', dap.repl.open, opts) -- open REPL
	vim.keymap.set('n', 'h', dap.hover, opts)    -- hover variables

	-- Run to cursor
	vim.keymap.set('n', 'R', dap.run_to_cursor, opts)
end

-- ===============================
-- Automatically set keymaps when DAP starts
-- ===============================
vim.api.nvim_create_autocmd("User", {
	pattern = "DAPStarted",
	callback = function()
		print("Debug session started.")
		set_dap_keymaps()
	end
})

-- Optional: Clear keymaps when DAP stops
vim.api.nvim_create_autocmd("User", {
	pattern = "DAPTerminated",
	callback = function()
		-- Keymaps are buffer-local, they disappear automatically
	end
})
