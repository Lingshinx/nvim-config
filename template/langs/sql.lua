---@type config.language.Config
return {
  formatter = "sqlfmt",
  lsp = "postgres_lsp",
  package = "postgres-language-server",
  plugin = {
    {
      "tpope/vim-dadbod",
      cmd = "DB",
    },
  },
}
