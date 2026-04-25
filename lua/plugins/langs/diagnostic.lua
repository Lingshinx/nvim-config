return {
  "rachartier/tiny-inline-diagnostic.nvim",
  lazy = true,
  event = { "BufReadPre", "BufNewFile", "BufWritePre" },
  opts = {
    preset = "powerline",
    options = {
      use_icons_from_diagnostic = false,
      multilines = {
        enabled = true,
      },
    },
  },
}
