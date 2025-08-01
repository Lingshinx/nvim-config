return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    render_modes = { "n", "c", "t", "V" },
    code = {
      sign = false,
      width = "block",
      border = "thin",
      below = "",
      language_border = "",
      right_pad = 1,
    },
    heading = {
      sign = false,
      position = "inline",
      icons = {
        "󰼏 ",
        "󰎨 ",
        "󰼑 ",
        "󰎲 ",
        "󰼓 ",
        "󰎴 ",
      },
    },
    checkbox = {
      enabled = true,
      checked = {
        scope_highlight = "@markup.strikethrough",
      },
    },
  },
}
