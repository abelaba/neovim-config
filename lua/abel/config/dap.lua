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

local C = require("catppuccin.palettes").get_palette()

local debug_theme = {
	normal = {
		a = { bg = C.peach, fg = C.base, gui = "bold" },
		b = { bg = C.surface1, fg = C.text },
		c = { bg = C.base, fg = C.text },
	},

	insert = {
		a = { bg = C.green, fg = C.base, gui = "bold" },
		b = { bg = C.surface1, fg = C.text },
		c = { bg = C.base, fg = C.text },
	},

	visual = {
		a = { bg = C.blue, fg = C.base, gui = "bold" },
		b = { bg = C.surface1, fg = C.text },
		c = { bg = C.base, fg = C.text },
	},

	replace = {
		a = { bg = C.mauve, fg = C.base, gui = "bold" },
		b = { bg = C.surface1, fg = C.text },
		c = { bg = C.base, fg = C.text },
	},

	command = {
		a = { bg = C.yellow, fg = C.base, gui = "bold" },
		b = { bg = C.surface1, fg = C.text },
		c = { bg = C.base, fg = C.text },
	},

	inactive = {
		a = { bg = C.mantle, fg = C.overlay1 },
		b = { bg = C.mantle, fg = C.overlay1 },
		c = { bg = C.mantle, fg = C.overlay1 },
	},
}

local lualine = require("lualine")
local function set_debug_lualine_theme()
	lualine.setup({ options = { theme = debug_theme } })
end

local function restore_lualine_theme()
	lualine.setup({ options = { theme = "auto" } })
end

dap.listeners.after.event_initialized["lualine_theme"] = set_debug_lualine_theme
dap.listeners.before.event_terminated["lualine_theme"] = restore_lualine_theme
dap.listeners.before.event_exited["lualine_theme"] = restore_lualine_theme


require("dap-python").setup(vim.fn.getcwd() .. "/.venv/bin/python")
dap.configurations.python = {
	{
		type = "python",
		request = "launch",
		name = "Click: run slidev",
		program = "run_script.py",
		justMyCode = true,
		console = "integratedTerminal",
	},
}
