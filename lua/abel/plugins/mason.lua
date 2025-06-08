return {
	{ "williamboman/mason.nvim", opts = {} },
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local capabilities = require("blink.cmp").get_lsp_capabilities()
						require("lspconfig")[server_name].setup({ capabilities = capabilities })
					end,
				},
			})
		end,
	},
}
