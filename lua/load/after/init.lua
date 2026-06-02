local diagnostics = require("config.icons").diagnostics

vim.diagnostic.config {
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = diagnostics.Error,
      [vim.diagnostic.severity.WARN] = diagnostics.Warn,
      [vim.diagnostic.severity.HINT] = diagnostics.Hint,
      [vim.diagnostic.severity.INFO] = diagnostics.Info,
    },
  },
}

require("utils.manager").setup()

if vim.g.config_installer == "nix" then require("utils.nix").setup() end
