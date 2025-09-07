local diagnostics = require("config.icons").diagnostics

vim.lsp.config("*", {})
vim.diagnostic.config {
  -- virtual_text = { prefix = "●" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = diagnostics.Error,
      [vim.diagnostic.severity.WARN] = diagnostics.Warn,
      [vim.diagnostic.severity.HINT] = diagnostics.Hint,
      [vim.diagnostic.severity.INFO] = diagnostics.Info,
    },
  },
}
