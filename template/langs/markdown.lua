return {
  lsp = "marksman",
  plugins = {
    {
      "iamcco/markdown-preview.nvim",
      ft = { "markdown" },
      cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
      before = function() vim.g.mkdp_filetypes = { "markdown" } end,
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
