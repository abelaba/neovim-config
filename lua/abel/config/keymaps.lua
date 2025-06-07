local builtin = require("telescope.builtin")

-- Shared layout config
local small_layout = {
	previewer = false,
	layout_strategy = "center",
	layout_config = {
		width = 0.4,
		height = 0.4,
		prompt_position = "top",
	},
}

local map = vim.keymap.set

map("n", "<leader>q", function()
	local api_ok, api = pcall(require, "nvim-tree.api")
	local path

	-- Check if nvim-tree is focused
	if api_ok and vim.bo.filetype == "NvimTree" then
		local node = api.tree.get_node_under_cursor()
		path = node and node.absolute_path

		-- If it's a file, use its parent directory
		if path then
			local stat = vim.loop.fs_stat(path)
			if stat and stat.type == "file" then
				path = vim.fn.fnamemodify(path, ":h")
			end
		end
	end

	-- Default to global search if path is not set
	local opts = small_layout
	if path then
		opts.search_dirs = { path }
	end

	opts.additional_args = function()
		return { "--hidden", "--ignore" }
	end

	builtin.find_files(opts)
end, { desc = "Telescope find files" })

map("n", "<leader>f", function()
	local api_ok, api = pcall(require, "nvim-tree.api")
	local path

	-- Check if nvim-tree is focused
	if api_ok and vim.bo.filetype == "NvimTree" then
		local node = api.tree.get_node_under_cursor()
		path = node and node.absolute_path

		-- If it's a file, use its parent directory
		if path then
			local stat = vim.loop.fs_stat(path)
			if stat and stat.type == "file" then
				path = vim.fn.fnamemodify(path, ":h")
			end
		end
	end

	-- Default to global search if path is not set
	local opts = {}
	if path then
		opts.search_dirs = { path }
	end

	opts.additional_args = function()
		return { "--hidden", "--ignore" }
	end

	opts.layout_strategy = "vertical"
	opts.layout_config = {
		vertical = {
			prompt_position = "top",
			mirror = true,
			width = 0.8,
			height = 0.9,
		},
	}

	opts.sorting_strategy = "ascending"

	builtin.live_grep(opts)
end, { desc = "Smart Live Grep (nvim-tree-aware)" })

map("n", "<leader>v", function()
	builtin.buffers(vim.tbl_extend("force", small_layout, {
		sort_mru = true,
		ignore_current_buffer = true,
	}))
end, { noremap = true, silent = true, desc = "Telescope buffers (small layout)" })

map("n", "<leader>S", function()
	builtin.find_files({
		prompt_title = "Neovim Config",
		cwd = vim.fn.stdpath("config"),
	})
end, { desc = "Find Neovim Config Files" })

map("n", "<leader>G", require("telescope.builtin").git_status, { desc = "Git Files" })
map("n", "<leader>P", ":Telescope projects<CR>", { desc = "Recent Projects" })

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

map("n", "<leader>b", "<cmd>NvimTreeToggle<CR>", { noremap = true, silent = true })
map("n", "<C-t>", ":terminal<CR>", { noremap = true, silent = true })
-- map("n", "<leader>c", function()
-- 	local virtual_text = require("codeium.config").options.virtual_text
-- 	virtual_text.manual = not virtual_text.manual
-- 	print("Codeium virtual text is now " .. (not virtual_text.manual and "enabled" or "disabled"))
-- end, { noremap = true, silent = true, desc = "Toggle Codeium virtual text" })
map("n", "<leader>F", '<cmd>lua require("spectre").toggle()<CR>', {
	desc = "Toggle Spectre",
})
map("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
	desc = "Search current word",
})
map("n", "<c-f>", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
	desc = "Search on current file",
})

map("n", "<leader>g", "<cmd>Neogit cwd=%:p:h<CR>", { desc = "Neogit" })

map("n", "<leader>x", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "diagnostics" })

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
map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "Undo stage hunk" })
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
map("n", "<leader>td", gitsigns.toggle_deleted, { desc = "Toggle deleted" })

-- Text object
map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
map("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
