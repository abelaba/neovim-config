return {
  { "folke/noice.nvim", opts = { cmdline = {
    view = "cmdline",
  }, presets = { command_palette = false } } },
  { "akinsho/bufferline.nvim", enabled = false },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "macchiato", -- options: latte, frappe, macchiato, mocha
      transparent_background = not vim.g.neovide,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
