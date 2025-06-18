require("user.neovide")
require("user.filetype")
require("user.treesitter")

local abbr = require("user.abbr")
for k, v in pairs(abbr) do
  vim.cmd("iabbrev" .. " " .. k .. " " .. v)
end
