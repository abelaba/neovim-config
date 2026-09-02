-- :checkhealth abel — verifies the per-language tooling declared in
-- abel/languages.lua against the live config.
local M = {}

local health = vim.health

local function check_treesitter(ft, spec)
	local parser = spec.treesitter or ft
	if #vim.api.nvim_get_runtime_file("parser/" .. parser .. ".*", false) > 0 then
		health.ok("treesitter parser: " .. parser)
	else
		health.warn("treesitter parser '" .. parser .. "' not installed", { ":TSInstall " .. parser })
	end
end

local function check_lsp(spec)
	for _, server in ipairs(spec.lsp or {}) do
		local ok, cfg = pcall(function()
			return vim.lsp.config[server]
		end)
		if not ok or not cfg then
			health.warn(
				"LSP server '" .. server .. "' not configured",
				{ "install it via :Mason", "settings live in abel/config/nvim-lsp-config.lua" }
			)
		elseif type(cfg.cmd) == "table" and vim.fn.executable(cfg.cmd[1]) ~= 1 then
			health.warn("LSP server '" .. server .. "' configured but '" .. cfg.cmd[1] .. "' is not executable", {
				"install it via :Mason",
			})
		else
			health.ok("LSP server: " .. server)
		end
	end
end

local function check_formatter(ft, spec)
	if not spec.formatter then
		return
	end
	local ok, conform = pcall(require, "conform")
	if not ok then
		health.error("conform.nvim not available")
		return
	end
	local formatters = conform.formatters_by_ft[ft]
	if not formatters then
		health.warn(
			"no formatters for filetype '" .. ft .. "'",
			{ "add to formatters_by_ft in abel/plugins/coding/conform.lua" }
		)
		return
	end
	local available, missing = {}, {}
	for _, name in ipairs(formatters) do
		if type(name) == "string" then
			table.insert(conform.get_formatter_info(name).available and available or missing, name)
		end
	end
	if #available > 0 then
		health.ok("formatter: " .. table.concat(available, ", "))
	end
	if #missing > 0 then
		health.warn(
			"formatter(s) configured but not available: " .. table.concat(missing, ", "),
			{ "install via :Mason or system package manager" }
		)
	end
end

local function check_dap(ft, spec)
	if not spec.dap then
		return
	end
	local ok, dap = pcall(require, "dap")
	if not ok then
		health.error("nvim-dap not available")
		return
	end
	local configs = dap.configurations[ft]
	if not configs or #configs == 0 then
		health.warn(
			"no DAP configurations for '" .. ft .. "'",
			{ "add dap.configurations." .. ft .. " in abel/config/dap.lua" }
		)
		return
	end
	health.ok(("DAP: %d configuration(s)"):format(#configs))
	for _, config in ipairs(configs) do
		if not dap.adapters[config.type] then
			health.warn(
				"DAP configuration '" .. (config.name or "?") .. "' uses missing adapter '" .. config.type .. "'",
				{ "define dap.adapters." .. config.type .. " in abel/config/dap.lua" }
			)
		end
	end
end

local function check_neotest(spec)
	if not spec.neotest then
		return
	end
	local ok, neotest_config = pcall(require, "neotest.config")
	if not ok then
		health.error("neotest not available")
		return
	end
	for _, adapter in ipairs(neotest_config.adapters or {}) do
		if (type(adapter) == "table" and adapter.name) == spec.neotest then
			health.ok("neotest adapter: " .. spec.neotest)
			return
		end
	end
	health.warn("neotest adapter '" .. spec.neotest .. "' not registered", {
		"plugin goes in abel/plugins/debug_testing/neotest.lua",
		"adapters list is in abel/config/neotest.lua",
	})
end

function M.check()
	local languages = require("abel.languages")
	local names = vim.tbl_keys(languages)
	table.sort(names)
	for _, ft in ipairs(names) do
		local spec = languages[ft]
		health.start("Language: " .. ft)
		check_treesitter(ft, spec)
		check_lsp(spec)
		check_formatter(ft, spec)
		check_dap(ft, spec)
		check_neotest(spec)
		for _, note in ipairs(spec.extra or {}) do
			health.info(note)
		end
	end
end

return M
