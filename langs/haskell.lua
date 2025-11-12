---@type Config.LangConfig
return {
  { "haskll", formatter = "fourmolu", lsp = "haskell-language-server" },
  { "cabal", formatter = "cabal_fmt" },
  plugins = {
    {
      "mrcjkb/haskell-snippets.nvim",
      dependencies = { "L3MON4D3/LuaSnip" },
      ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
      config = function()
        require("luasnip").add_snippets("haskell", require("haskell-snippets").all, { key = "haskell" })
      end,
    },
    {
      "mrcjkb/haskell-tools.nvim",
      version = false,
      ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
      keys = {
        {
          "<localleader>e",
          "<cmd>HlsEvalAll<cr>",
          ft = "haskell",
          desc = "Evaluate All",
        },
        {
          "<localleader>h",
          function() require("haskell-tools").hoogle.hoogle_signature() end,
          ft = "haskell",
          desc = "Hoogle Signature",
        },
        {
          "<localleader>r",
          function() require("haskell-tools").repl.toggle() end,
          ft = "haskell",
          desc = "REPL (Package)",
        },
        {
          "<localleader>R",
          function() require("haskell-tools").repl.toggle(vim.api.nvim_buf_get_name(0)) end,
          ft = "haskell",
          desc = "REPL (Buffer)",
        },
      },
    },
  },
}
