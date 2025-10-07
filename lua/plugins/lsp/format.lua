return {
  "stevearc/conform.nvim",
  event = "LazyFile",
  opts = function()
    return {
      formatters_by_ft = require("config.lsp").formatters,
    }
  end,
  keys = {
    {
      "<leader>cf",
      function() require("conform").format() end,
      mode = { "n", "v" },
      desc = "Format",
    },
  },
}
