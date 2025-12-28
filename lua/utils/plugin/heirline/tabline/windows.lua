local utils = require "utils.plugin.heirline.utils"
local grapple = require "grapple"
local events = require("utils.plugin.heirline.utils").eventsToUpdateTabline

local WinIcon = {
  init = function(self)
    self.icon, self.hl = Snacks.util.icon(self.winname)
  end,
  provider = function(self) return " " .. self.icon end,
  hl = function(self) return self.hl end,
}

local Grapple = {
  init = function(self) self.grapple_opts = { buffer = vim.api.nvim_win_get_buf(self.winnr) } end,
  update = { "User", pattern = "GrappleToggled", callback = function() vim.cmd.redrawtabline() end },
  {
    condition = function(self) return grapple.exists(self.grapple_opts) end,
    provider = function(self) return "󰛢" .. (grapple.name_or_index(self.grapple_opts) or "") .. " " end,
    hl = { fg = "yellow" },
  },
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
  Grapple,
  hl = function(self) return self.is_active and "Normal" or { fg = "gray" } end,
}
