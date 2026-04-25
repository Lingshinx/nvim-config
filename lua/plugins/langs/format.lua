return {
  "stevearc/conform.nvim",
  lazy = true,
  event = { "BufReadPre", "BufNewFile", "BufWritePre" },
  keys = {
    {
      "<leader>cf",
      function() require("conform").format() end,
      mode = { "n", "v" },
      desc = "Format",
    },
  },
}
