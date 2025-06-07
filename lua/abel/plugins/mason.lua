return {
	{ "williamboman/mason.nvim", config=true },
	{ "williamboman/mason-lspconfig.nvim", config = function()
	handlers = {
		function(server_name)
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			require("lspconfig")[server_name].setup({ capabilities = capabilities })
		end,
	}
end
	},
}