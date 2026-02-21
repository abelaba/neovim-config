local map = vim.keymap.set
local wk = require("which-key")


wk.add({ { "<leader>h", group = "Gitsigns" } })
wk.add({ { "<leader>q", group = "Persistence" } })
wk.add({ { "<leader>t", group = "Neotest" } })
wk.add({ { "<leader>d", group = "DAP" } })
wk.add({ { "<leader>b", group = "Buffer switching" } })
wk.add({ { "<leader>s", group = "Buffer controls" } })
wk.add({ { "<leader>u", group = "UI controls" } })
wk.add({ { "<leader>x", group = "Trouble" } })

-- Map Ctrl+Z to undo
map({ "n", "v", "x" }, "<C-z>", "u", { noremap = true, silent = true })
map("i", "<C-z>", "<C-o>u", { noremap = true, silent = true })
-- Ctrl+C as global copy (yanking to clipboard)
map({ "n", "v", "x" }, "<C-c>", '"+y', { noremap = true, silent = true })
map("i", "<C-c>", '<Esc>"+y', { noremap = true, silent = true })

-- Ctrl+V as global paste (pasting from clipboard)
map({ "n", "v", "x" }, "<C-v>", '"+p', { noremap = true, silent = true })
map("i", "<C-v>", '<Esc>"+p', { noremap = true, silent = true })

-- Map Ctrl+X to cut (yank and delete to clipboard)
map({ "n", "v", "x" }, "<C-x>", '"+d', { noremap = true, silent = true })
map("i", "<C-x>", '<Esc>"+d', { noremap = true, silent = true })


-- Map Ctrl+S to save
map({ "n", "v", "x" }, "<C-s>", ":w<CR>", { noremap = true, silent = true })
map("i", "<C-s>", "<Esc>:w<CR>", { noremap = true, silent = true })
-- Map Ctrl + A
map({ "n", "i", "v", "x" }, "<C-a>", "<Esc>ggVG", { noremap = true, silent = true })

map({ "n", "v", "x" }, "<leader>w", ":bd<CR>", { noremap = true, silent = true, desc = "Close Buffer" })
map("n", "<C-t>", ":terminal<CR>", { noremap = true, silent = true })
map("n", "<leader>c", function()
	local virtual_text = require("codeium.config").options.virtual_text
	virtual_text.manual = not virtual_text.manual
	print("Codeium virtual text is now " .. (not virtual_text.manual and "enabled" or "disabled"))
end, { noremap = true, silent = true, desc = "Toggle Codeium virtual text" })

local gitsigns = require("gitsigns")
map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk" })
map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk" })
map("v", "<leader>hs", function() gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
	{ desc = "Stage hunk" })
map("v", "<leader>hr", function() gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
	{ desc = "Reset hunk" })
map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage buffer" })
map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset buffer" })
map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk" })
map("n", "<leader>hb", function() gitsigns.blame_line({ full = true }) end, { desc = "Blame line" })
map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle current line blame" })
map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff this" })
map("n", "<leader>hD", function() gitsigns.diffthis("~") end, { desc = "Diff this ~" })
map("n", "<leader>gg", ":GitTab<CR>", { desc = "GitUI" })

-- Text object
map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
map("t", "<C-space>", [[<C-\><C-n>]], { noremap = true, silent = true })
map("n", "<leader>e", function()
	local util = require("lspconfig.util")
	local path = vim.api.nvim_buf_get_name(0)
	local root = util.root_pattern(".git")(path) or vim.fn.getcwd()
	require("neo-tree.command").execute({
		toggle = true,
		dir = root,
	})
end, { noremap = true, silent = true, desc = "Toggle Neo-tree at project root" })
map({ "t", "n" }, "<leader>`", function()
	Snacks.terminal()
end, { desc = "Close terminal", silent = true })

-- buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
map("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete Other Buffers" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })


-- Load the default session for the current working directory
map("n", "<leader>qs", function() require("persistence").load() end, { desc = "Load session for current directory" })
-- Select a session to load from a list
map("n", "<leader>qS", function() require("persistence").select() end, { desc = "Select session to load" })
-- Load the last saved session regardless of directory
map("n", "<leader>ql", function() require("persistence").load({ last = true }) end, { desc = "Load last session" })
-- Disable Persistence so the current session won't be saved on exit
map("n", "<leader>qd", function() require("persistence").stop() end,
	{ desc = "Disable session saving (stop Persistence)" })


-- normal mode
map("n", "d", '"_d', { noremap = true })
map("n", "D", '"_D', { noremap = true })
map("n", "x", '"_x', { noremap = true })
map("n", "c", '"_c', { noremap = true })
map("n", "C", '"_C', { noremap = true })
map("n", "dd", '"_dd', { noremap = true })

-- visual mode
map("v", "d", '"_d', { noremap = true })
map("v", "x", '"_x', { noremap = true })
map("v", "c", '"_c', { noremap = true })


-- =========================
-- Neotest + DAP keymaps
-- =========================

local neotest = require("neotest")
local dap = require("dap")
local dapui = require("dapui")

-- -------------------------
-- Neotest: run tests
-- -------------------------

map("n", "<leader>tn", function() neotest.run.run() end, { desc = "Run nearest test" })
map("n", "<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end, { desc = "Run test file" })
map("n", "<leader>ts", function() neotest.run.run({ suite = true }) end, { desc = "Run test suite" })
map("n", "<leader>tl", function() neotest.run.run_last() end, { desc = "Run last test" })

-- -------------------------
-- Neotest: debug tests (DAP)
-- -------------------------

map("n", "<leader>td", function() neotest.run.run({ strategy = "dap" }) end, { desc = "Debug nearest test" })
map("n", "<leader>tD", function() neotest.run.run(vim.fn.expand("%"), { strategy = "dap" }) end,
	{ desc = "Debug test file" })

-- -------------------------
-- Neotest UI
-- -------------------------

map("n", "<leader>to", function() neotest.output.open({ enter = true }) end, { desc = "Open test output" })
map("n", "<leader>tO", function() neotest.output_panel.toggle() end, { desc = "Toggle test output panel" })
map("n", "<leader>tt", function() neotest.summary.toggle() end, { desc = "Toggle test summary" })

-- -------------------------
-- DAP: core debugging
-- -------------------------
map("n", "<leader>dc", dap.continue, { desc = "DAP continue" })
map("n", "<leader>do", dap.step_over, { desc = "DAP step over" })
map("n", "<leader>di", dap.step_into, { desc = "DAP step into" })
map("n", "<leader>dO", dap.step_out, { desc = "DAP step out" })

map("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP toggle breakpoint" })
map("n", "<leader>dC", dap.clear_breakpoints, { desc = "DAP clear breakpoints" })
map("n", "<leader>dB", function()
	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "DAP conditional breakpoint" })

map("n", "<leader>dr", dap.restart, { desc = "DAP restart" })
map("n", "<leader>dq", dap.terminate, { desc = "DAP terminate" })
map("n", "<leader>dn", "<cmd>DapNew<cr>", { desc = "DAP new session" })

-- -------------------------
-- DAP UI
-- -------------------------

map("n", "<leader>du", function()
	-- Close Neo-tree if it's currently loaded/open
	if package.loaded["neo-tree"] then
		require("neo-tree.sources.manager").close_all()
	end

	dapui.toggle()
end, { desc = "DAP UI toggle" })
map("n", "<leader>de", dapui.eval, { desc = "DAP eval under cursor" })
