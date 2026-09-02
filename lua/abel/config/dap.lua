local dap = require("dap")
local dapui = require("dapui")

dapui.setup()
require("nvim-dap-virtual-text").setup({
	commented = true, -- Show virtual text alongside comment
})

vim.fn.sign_define("DapBreakpoint", {
	text = "",
	texthl = "DiagnosticSignError",
	linehl = "",
	numhl = "",
})

vim.fn.sign_define("DapBreakpointRejected", {
	text = "",
	texthl = "DiagnosticSignError",
	linehl = "",
	numhl = "",
})

vim.fn.sign_define("DapStopped", {
	text = "",
	texthl = "DiagnosticSignWarn",
	linehl = "Visual",
	numhl = "DiagnosticSignWarn",
})


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

dap.set_exception_breakpoints({ "raised" })


local python = require("abel.utils.python")

-- The adapter runs on Mason's debugpy install; the debugged program runs on
-- the interpreter returned by resolve_python (venv, pixi, conda, ...).
local dap_python = require("dap-python")
dap_python.setup(python.debugpy_python())
dap_python.resolve_python = python.find_project_python

table.insert(dap.configurations.python, {
	type = "python",
	request = "launch",
	name = "Launch current file (justMyCode=false)",
	program = "${file}",
	justMyCode = false,
	console = "integratedTerminal",
})
