return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@module "snacks"
  ---@type snacks.Config
  opts = {
    picker = {
      enabled = true,
      matcher = {
        frecency = true,
      },
      formatters = {
        selected = {
          unselected = false,
        },
      },
      win = {
        input = {
          keys = {
            ["<C-BS>"] = { "<c-s-w>", mode = { "i" }, expr = true, desc = "delete word" },
            ["<C-Delete>"] = { "<C-Right><C-s-w>", mode = { "i" }, expr = true, desc = "delete word" },
          },
        },
      },
      icons = {
        ui = {
          live = "󰐰 ",
          hidden = "󰘓",
          ignored = "",
          follow = "󱕱",
          selected = "",
        },
      },
    },
  },
}
