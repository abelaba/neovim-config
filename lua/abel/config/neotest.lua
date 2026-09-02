require("neotest").setup({
	adapters = {
		require("neotest-python")({
			dap = { justMyCode = true },
			python = require("abel.utils.python").find_project_python,
		}),
		require("neotest-plenary"),
	},
})
