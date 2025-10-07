local config = require "config.highlight.config"
for hl_group, value in pairs(config.override or {}) do
  vim.api.nvim_set_hl(0, hl_group, value)
end
for hl_group, value in pairs(config.lingshin or {}) do
  vim.api.nvim_set_hl(0, "Lingshin" .. hl_group, value)
end
