---@type config.language.Config
return {
  { "haskell", formatter = "fourmolu" }, -- Install haskell language server by yourself plz
  { "cabal", formatter = "cabal_fmt", treesitter = false },
  plugins = {
    {
      "mrcjkb/haskell-snippets.nvim",
      ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
      after = function()
        require("luasnip").add_snippets("haskell", require("haskell-snippets").all, { key = "haskell" })
      end,
    },
    {
      "mrcjkb/haskell-tools.nvim",
      ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
      keys = {
        {
          "<localleader>e",
          function() require("haskell-tools").lsp.buf_eval_all() end,
          ft = "haskell",
          desc = "Evaluate",
        },
        {
          "<localleader>h",
          function() require("haskell-tools").hoogle.hoogle_signature() end,
          ft = "haskell",
          desc = "Hoogle Signature",
        },
        {
          "<localleader>r",
          function() require("haskell-tools").repl.toggle(vim.api.nvim_buf_get_name(0)) end,
          ft = "haskell",
          desc = "REPL (Buffer)",
        },
      },
    },
  },
}
