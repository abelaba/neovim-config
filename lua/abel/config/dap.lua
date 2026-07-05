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
