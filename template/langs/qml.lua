return {
  treesitter = "qmljs",
  lsp = {
    qmlls = {
      cmd = { vim.g.config_installer == "nix" and "qmlls6" or "qmlls", "-E" },
    },
  },
  nix = "qt6.qtlanguageserver",
}
