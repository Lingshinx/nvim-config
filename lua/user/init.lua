require("user.neovide")
require("user.filetype")
require("user.treesitter")

for k, v in pairs(require("user.abbr")) do
  vim.cmd("iabbrev" .. " " .. k .. " " .. v)
end

for k, v in pairs(require("user.lsp")) do
  vim.lsp.config[k] = v
  vim.lsp.enable(k)
end
