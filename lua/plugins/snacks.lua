return {
  "snacks.nvim",
  opts = {
    explorer = { enabled = false },
    dashboard = {
      preset = { header = require("config.header").greeting() },
    },
  },
}
