local utils = require "utils.plugin.heirline.utils"
local events = require("utils.plugin.heirline.utils").eventsToUpdateTabline

local WinIcon = {
  provider = function(self) return " " .. self.icon end,
  hl = function(self) return self.icon_hl end,
}

local WinName = { provider = function(self) return " " .. vim.fn.fnamemodify(self.winname, ":t") .. " " end }

return utils.make_winlist {
  flexible = 3,
  {
    WinIcon,
    WinName,
    update = events,
  },
  { WinIcon, update = events },
  hl = function(self) return self.is_active and "Normal" or { fg = "gray" } end,
}
