require("neotest").setup({
	adapters = {
		require("neotest-python")({
			dap = { justMyCode = true },
		}),
		require("neotest-plenary"),
	},
})
