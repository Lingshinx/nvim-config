---@type Config.LangConfig
return {
  formatter = "sqlfmt",
  lsp = "postgres_lsp",
  packages = "postgres-language-server",
  plugins = {
    {
      "tpope/vim-dadbod",
      cmd = "DB",
    },
  },
}
