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
        file = {
          filename_first = true,
          filename_only = true,
        },
        selected = {
          unselected = false,
        },
      },
    },
  },
}
