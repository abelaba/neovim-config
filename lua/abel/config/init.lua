vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

require("abel.config.keymaps")
require("abel.config.telescope")
require("abel.config.gittab")
require("abel.config.nvim-lsp-config")
require("abel.config.neotest")
require("abel.config.dap")
require("claudecode").setup()
require("abel.utils.agent_status").setup()
require("abel.utils.observability").setup()
