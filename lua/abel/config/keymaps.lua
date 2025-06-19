local map = vim.keymap.set

-- Map Ctrl+Z to undo
map("n", "<C-z>", "u", { noremap = true, silent = true })
map("i", "<C-z>", "<C-o>u", { noremap = true, silent = true })
map("v", "<C-z>", "u", { noremap = true, silent = true })
map("x", "<C-z>", "u", { noremap = true, silent = true })

-- Ctrl+C as global copy (yanking to clipboard)
map("n", "<C-c>", '"+y', { noremap = true, silent = true })
map("i", "<C-c>", '<Esc>"+y', { noremap = true, silent = true })
map("v", "<C-c>", '"+y', { noremap = true, silent = true })
map("x", "<C-c>", '"+y', { noremap = true, silent = true })

-- Ctrl+V as global paste (pasting from clipboard)
map("n", "<C-v>", '"+p', { noremap = true, silent = true })
map("i", "<C-v>", '<Esc>"+p', { noremap = true, silent = true })
map("v", "<C-v>", '"+p', { noremap = true, silent = true })
map("x", "<C-v>", '"+p', { noremap = true, silent = true })

-- Map Ctrl+X to cut (yank and delete to clipboard)
map("n", "<C-x>", '"+d', { noremap = true, silent = true })
map("i", "<C-x>", '<Esc>"+d', { noremap = true, silent = true })
map("v", "<C-x>", '"+d', { noremap = true, silent = true })
map("x", "<C-x>", '"+d', { noremap = true, silent = true })

-- Map Ctrl+S to save
map("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })
map("i", "<C-s>", "<Esc>:w<CR>", { noremap = true, silent = true })
map("v", "<C-s>", ":w<CR>", { noremap = true, silent = true })
map("x", "<C-s>", ":w<CR>", { noremap = true, silent = true })

-- Map Ctrl + A
map("n", "<C-a>", "ggVG", { noremap = true, silent = true })
map("i", "<C-a>", "<Esc>ggVG", { noremap = true, silent = true })
map("v", "<C-a>", "<Esc>ggVG", { noremap = true, silent = true })
map("x", "<C-a>", "<Esc>ggVG", { noremap = true, silent = true })

map("n", "<leader>w", ":bd<CR>", { noremap = true, silent = true, desc = "Close Buffer" })
map("v", "<leader>w", ":bd<CR>", { noremap = true, silent = true, desc = "Close Buffer" })
map("x", "<leader>w", ":bd<CR>", { noremap = true, silent = true, desc = "Close Buffer" })

map("n", "<C-t>", ":terminal<CR>", { noremap = true, silent = true })
map("n", "<leader>c", function()
	local virtual_text = require("codeium.config").options.virtual_text
	virtual_text.manual = not virtual_text.manual
	print("Codeium virtual text is now " .. (not virtual_text.manual and "enabled" or "disabled"))
end, { noremap = true, silent = true, desc = "Toggle Codeium virtual text" })

map("n", "<leader>g", "<cmd>Neogit cwd=%:p:h<CR>", { desc = "Neogit" })

local gitsigns = require("gitsigns")
map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk" })
map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk" })
map("v", "<leader>hs", function()
	gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "Stage hunk" })
map("v", "<leader>hr", function()
	gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "Reset hunk" })
map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage buffer" })
map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset buffer" })
map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk" })
map("n", "<leader>hb", function()
	gitsigns.blame_line({ full = true })
end, { desc = "Blame line" })
map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle current line blame" })
map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff this" })
map("n", "<leader>hD", function()
	gitsigns.diffthis("~")
end, { desc = "Diff this ~" })

-- Text object
map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
map("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
map("n", "<leader>e", function()
	local util = require("lspconfig.util")
	local path = vim.api.nvim_buf_get_name(0)
	local root = util.root_pattern(".git")(path) or vim.fn.getcwd()
	require("neo-tree.command").execute({
		toggle = true,
		dir = root,
	})
end, { noremap = true, silent = true, desc = "Toggle Neo-tree at project root" })
map("t", "<C-/>", function()
	Snacks.terminal()
end, { desc = "Close terminal", silent = true })

-- buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", function()
	Snacks.bufdelete()
end, { desc = "Delete Buffer" })
map("n", "<leader>bo", function()
	Snacks.bufdelete.other()
end, { desc = "Delete Other Buffers" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- Load the default session for the current working directory
map("n", "<leader>qs", function()
	require("persistence").load()
end, { desc = "Load session for current directory" })

-- Select a session to load from a list
map("n", "<leader>qS", function()
	require("persistence").select()
end, { desc = "Select session to load" })

-- Load the last saved session regardless of directory
map("n", "<leader>ql", function()
	require("persistence").load({ last = true })
end, { desc = "Load last session" })

-- Disable Persistence so the current session won't be saved on exit
map("n", "<leader>qd", function()
	require("persistence").stop()
end, { desc = "Disable session saving (stop Persistence)" })

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
