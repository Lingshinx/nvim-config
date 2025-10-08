return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = {},
  },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  {
    "marko-cerovac/material.nvim",
  },
  {
    "mvllow/modes.nvim",
    event = "VeryLazy",
    opts = {
      colors = {
        insert = "#c3e88d",
        replace = "#ff757f",
        visual = "#c099ff",
      },
      line_opacity = 0.15,
    },
  },
}
