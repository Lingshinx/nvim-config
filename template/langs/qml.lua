return {
  treesitter = "qmljs",
  lsp = {
    qmlls = {
      cmd = { vim.g.config_installer == "nix" and "qmlls6" or "/usr/lib/qt6/bin/qmlls", "-E" },
    },
  },
  formatter = "qmlformat",
  ftplugin = function()
    require("conform").formatters.qmlformat = {
      command = "/usr/lib/qt6/bin/qmlformat",
    }
  end,
  nix = "qt6.qtlanguageserver",
}
