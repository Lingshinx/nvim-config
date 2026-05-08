return {
  lsp = "marksman",
  plugins = {
    {
      "brianhuster/live-preview.nvim.git",
      cmd = "LivePreview",
      ft = { "markdown" },
    },
    {
      "MeanderingProgrammer/render-markdown.nvim",
      ft = "markdown",
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
          -- position = "inline",
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
    },
  },
}
