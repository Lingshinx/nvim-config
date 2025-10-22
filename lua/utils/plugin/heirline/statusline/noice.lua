local Diff = require "utils.plugin.heirline.statusline.diff"
return {
  init = function(self)
    if not package.loaded["noice"] then return end
    self.has_command = require("noice").api.status.command.has()
    self.has_mode = require("noice").api.status.mode.has()
  end,

  {
    condition = function(self) return self.has_command end,
    { provider = function() return require("noice").api.status.command.get() end },
    hl = { fg = "purple" },
  },
  { provider = "  ", condition = function(self) return self.has_command and self.has_mode end },
  {
    condition = function(self) return self.has_mode end,
    { provider = function() return require("noice").api.status.mode.get() end },
    hl = { fg = "orange" },
  },
  Diff,
}
