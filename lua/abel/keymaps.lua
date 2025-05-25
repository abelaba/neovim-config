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

vim.keymap.set("n", "<leader>f", function()
  builtin.find_files(small_layout)
end, { desc = "Telescope find files" })

vim.keymap.set("n", "<leader>q", function()
  builtin.live_grep({
    additional_args = function()
      return { "--hidden", "--no-ignore" }
    end,
      })
end, { desc = "Live Grep (Faster)" })

vim.keymap.set('n', '<leader>v', function()
  builtin.buffers(vim.tbl_extend("force", small_layout, {
    sort_mru = true,
    ignore_current_buffer = true,
  }))
end, { noremap = true, silent = true, desc = "Telescope buffers (small layout)" })

vim.keymap.set("n", "<leader>S", function()
	builtin.find_files({
		prompt_title = "Neovim Config",
		cwd = vim.fn.stdpath("config"),
	})
end, { desc = "Find Neovim Config Files" })

vim.keymap.set("n", "<leader>G", require("telescope.builtin").git_status, { desc = "Git Files" })

-- Map Ctrl+Z to undo
vim.api.nvim_set_keymap("n", "<C-z>", "u", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-z>", "<C-o>u", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-z>", "u", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "<C-z>", "u", { noremap = true, silent = true })

-- Ctrl+C as global copy (yanking to clipboard)
vim.api.nvim_set_keymap("n", "<C-c>", '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-c>", '<Esc>"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-c>", '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "<C-c>", '"+y', { noremap = true, silent = true })

-- Ctrl+V as global paste (pasting from clipboard)
vim.api.nvim_set_keymap("n", "<C-v>", '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-v>", '<Esc>"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-v>", '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "<C-v>", '"+p', { noremap = true, silent = true })

-- Map Ctrl+X to cut (yank and delete to clipboard)
vim.api.nvim_set_keymap("n", "<C-x>", '"+d', { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-x>", '<Esc>"+d', { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-x>", '"+d', { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "<C-x>", '"+d', { noremap = true, silent = true })

-- Map Ctrl+S to save
vim.api.nvim_set_keymap("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-s>", "<Esc>:w<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-s>", ":w<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "<C-s>", ":w<CR>", { noremap = true, silent = true })

-- Map Ctrl + A
vim.api.nvim_set_keymap("n", "<C-a>", "ggVG", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-a>", "<Esc>ggVG", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-a>", "<Esc>ggVG", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "<C-a>", "<Esc>ggVG", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<leader>w", ":bd<CR>", { noremap = true, silent = true, desc = "Close Buffer" })
vim.api.nvim_set_keymap("v", "<leader>w", ":bd<CR>", { noremap = true, silent = true, desc = "Close Buffer" })
vim.api.nvim_set_keymap("x", "<leader>w", ":bd<CR>", { noremap = true, silent = true, desc = "Close Buffer" })

vim.keymap.set("n", "<leader>b", "<cmd>NvimTreeToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-t>", ":terminal<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n", "<leader>c", function()
-- 	local virtual_text = require("codeium.config").options.virtual_text
-- 	virtual_text.manual = not virtual_text.manual
-- 	print("Codeium virtual text is now " .. (not virtual_text.manual and "enabled" or "disabled"))
-- end, { noremap = true, silent = true, desc = "Toggle Codeium virtual text" })

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*",
	callback = function()
		vim.cmd("FormatWrite")
	end,
})

vim.keymap.set("n", "<leader>F", '<cmd>lua require("spectre").toggle()<CR>', {
	desc = "Toggle Spectre",
})
vim.keymap.set("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
	desc = "Search current word",
})
vim.keymap.set("n", "<c-f>", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
	desc = "Search on current file",
})

vim.keymap.set("n", "<leader>g", "<cmd>Neogit cwd=%:p:h<CR>", { desc = "Neogit" })

vim.keymap.set("n", "<leader>x", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "diagnostics" })

