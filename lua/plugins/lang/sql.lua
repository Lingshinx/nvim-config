return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      sqlfmt = {
        prepend_args = { "-l", "50" },
      },
    },
    formatters_by_ft = {
      sql = { "sqlfmt" },
    },
  },
}
