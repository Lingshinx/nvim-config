local Mode = require "utils.plugin.heirline.statusline.mode"
local Ruler = require "utils.plugin.heirline.statusline.ruler"
local Noice = require "utils.plugin.heirline.statusline.noice"
local Diagnostic = require "utils.plugin.heirline.statusline.diagnostic"
local File = require "utils.plugin.heirline.statusline.file"
local Cut = { provider = "%<" }
local Align = { provider = " %= " }

return {
  Mode,
  Cut, ---
  Diagnostic,
  File,
  Align, ---
  Noice,
  Ruler,
  init = function(self)
    self.mode = vim.fn.mode()
    self.mode_color = self.mode_colors[self.mode]
  end,
  static = {
    mode_colors = {
      n = "blue",
      i = "green",
      v = "purple",
      V = "purple",
      ["\22"] = "purple",
      c = "yellow",
      s = "pink",
      S = "pink",
      ["\19"] = "pink",
      R = "red",
      r = "blue",
      ["!"] = "red",
      t = "aqua",
    },
  },
}
