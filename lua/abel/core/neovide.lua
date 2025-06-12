-- ======================
--      Neovide Setup
-- ======================
if vim.g.neovide then
	-- Font
	vim.o.guifont = "Hack Nerd Font:h10" -- Set your preferred font and size
	vim.g.neovide_fullscreen = false -- Start Neovide in fullscreen mode

	-- Cursor Effects
	-- vim.g.neovide_cursor_vfx_mode = "lightbulb" -- Options: 'pixiedust', 'torpedo', 'ripple', 'wireframe', 'sonicboom', 'railgun', 'lightbulb'
	vim.g.neovide_cursor_animation_length = 0.05
	vim.g.neovide_cursor_trail_size = 0.1
	vim.g.neovide_cursor_antialiasing = true
	vim.g.neovide_cursor_animate_command_line = true

	-- Transparency
	vim.g.neovide_opacity = 0.96

	-- Floating Blur (if transparency is used)
	vim.g.neovide_floating_blur_amount_x = 2.0
	vim.g.neovide_floating_blur_amount_y = 2.0

	-- Remember window size
	vim.g.neovide_remember_window_size = true

	-- Scroll animation
	vim.g.neovide_scroll_animation_length = 0.3

	-- Theme
	vim.g.neovide_theme = "dark" -- 'auto', 'dark', or 'light'

	-- Logo (⌘ key) support on macOS or Windows
	vim.g.neovide_input_use_logo = true

	-- Hide mouse when typing
	vim.g.neovide_hide_mouse_when_typing = true
	vim.cmd([[highlight Normal guibg=#282A36]])
	vim.keymap.set("n", "<F11>", function()
		vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
	end, { desc = "Toggle Neovide Fullscreen" })
end
