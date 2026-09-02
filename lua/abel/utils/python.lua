-- Shared Python interpreter resolution for DAP and neotest.
--
-- Resolution order:
--   1. Activated environment: VIRTUAL_ENV, or CONDA_PREFIX (set by
--      `pixi shell` / `pixi run` and conda)
--   2. Walking up from the project root: .venv/, then pixi's default
--      environment at .pixi/envs/default/
--   3. python3 on PATH

local M = {}

local function executable(path)
	return vim.fn.executable(path) == 1 and path or nil
end

---@param root string|nil directory to search from, defaults to cwd
---@return string python interpreter path
function M.find_project_python(root)
	for _, env in ipairs({ vim.env.VIRTUAL_ENV, vim.env.CONDA_PREFIX }) do
		if env and env ~= "" then
			local python = executable(env .. "/bin/python")
			if python then
				return python
			end
		end
	end

	local dir = root or vim.fn.getcwd()
	while dir do
		local python = executable(dir .. "/.venv/bin/python")
			or executable(dir .. "/.pixi/envs/default/bin/python")
		if python then
			return python
		end
		local parent = vim.fs.dirname(dir)
		dir = parent ~= dir and parent or nil
	end

	return vim.fn.exepath("python3")
end

-- Interpreter used to run the debugpy adapter itself. debugpy only needs to
-- be installed here, not in each project environment; Mason provides it
-- (:MasonInstall debugpy).
---@return string python interpreter path
function M.debugpy_python()
	local mason = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
	return executable(mason) or M.find_project_python()
end

return M
