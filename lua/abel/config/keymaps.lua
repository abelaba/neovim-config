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
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { noremap = true, silent = true })
