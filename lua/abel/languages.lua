-- Declarative checklist of per-language tooling. Run :checkhealth abel to
-- verify every declared item and see what is missing.
--
-- Adding a new language:
--   1. Declare it below (copy an existing entry).
--   2. Treesitter parser: :TSInstall <parser>
--   3. LSP server: install via :Mason (mason-lspconfig configures it
--      automatically); server-specific settings go in
--      abel/config/nvim-lsp-config.lua
--   4. Formatter: add to formatters_by_ft in abel/plugins/coding/conform.lua
--      and install the binary (:Mason or system package)
--   5. Debugger: adapter + dap.configurations.<ft> in abel/config/dap.lua
--   6. Tests: adapter plugin in abel/plugins/debug_testing/neotest.lua and
--      adapters list in abel/config/neotest.lua
--   7. Run :checkhealth abel until everything is green.
--
-- Entry fields (all optional except being listed):
--   treesitter  parser name, defaults to the filetype key
--   lsp         list of LSP server names that should be configured
--   formatter   true if conform should have formatters for this filetype
--   dap         true if dap.configurations.<ft> should exist
--   neotest     name of the neotest adapter that should be registered
--   extra       list of free-form reminders shown as info in checkhealth

return {
	python = {
		lsp = { "pyright" },
		formatter = true,
		dap = true,
		neotest = "neotest-python",
		extra = {
			"debugpy runs from Mason (:MasonInstall debugpy); project interpreter is resolved by abel/utils/python.lua (.venv, pixi, conda)",
		},
	},
	lua = {
		lsp = { "lua_ls" },
		formatter = true,
		neotest = "neotest-plenary",
	},
}
