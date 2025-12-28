local Tabpages = require "utils.plugin.heirline.tabline.tabpages"
local Windows = require "utils.plugin.heirline.tabline.windows"
local Align = require("utils.plugin.heirline.utils").Align
local Tail = { provider = "  ", hl = "Tabline" }

return {
  Tabpages,
  Align,
  Windows,
  Tail,
}
