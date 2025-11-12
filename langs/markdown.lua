return {
  lsp = "marksman",
  plugins = {
    {
      "iamcco/markdown-preview.nvim",
      cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
      build = "cd app && npm install && git restore .",
      init = function() vim.g.mkdp_filetypes = { "markdown" } end,
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
