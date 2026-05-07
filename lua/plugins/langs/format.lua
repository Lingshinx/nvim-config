return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile", "BufWritePre" },
  keys = {
    {
      "<leader>cf",
      function() require("conform").format() end,
      mode = { "n", "v" },
      desc = "Format",
    },
  },
  after = function()
    vim.g.autoformat = true
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    local conform = require "conform"
    conform.formatters_by_ft = require("load.langs").formatters_by_ft
    vim.api.nvim_create_autocmd("BufWritePre", {
      desc = "Auto Format buffer",
      callback = function(args)
        if vim.g.autoformat and vim.b.autoformat ~= false then conform.format { bufnr = args.buf } end
      end,
    })
  end,
}
