local diagnostics = require("config.icons").diagnostics

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

vim.filetype.add {
  extension = { rasi = "rasi", rofi = "rasi", wofi = "rasi" },
  pattern = {
    [".*/waybar/config"] = "jsonc",
    [".*/kitty/.+%.conf"] = "kitty",
    [".*/hypr/.+%.conf"] = "hyprlang",
  },
}

vim.treesitter.language.register("bash", "kitty")

local langs = require ("utils.language").Langs.new()

require("utils.fs").load_each(
  vim.fn.stdpath "config",
  "config.langs",
  function(name, config) langs:solve(name, config) end
)

langs:config()

return langs
