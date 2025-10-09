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
      layouts = {
        vscode = {
          layout = {
            row = 2,
          },
        },
        sidebar = {
          preview = "main",
          layout = {
            backdrop = false,
            width = 40,
            min_width = 40,
            height = 0,
            position = "left",
            box = "vertical",
            {
              win = "input",
              height = 1,
              border = "hpad",
              title_pos = "center",
            },
            { win = "list", border = "none" },
            { win = "preview", title = "{preview}", height = 0.4, border = "top" },
          },
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
