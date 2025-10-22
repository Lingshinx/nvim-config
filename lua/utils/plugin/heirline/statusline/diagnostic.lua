local conditions = require "heirline.conditions"
local icons = require "config.icons"

return {
  condition = conditions.has_diagnostics,

  init = function(self)
    local severitys = vim.diagnostic.severity
    local function get(severity) return #vim.diagnostic.get(0, { severity = severity }) end

    self.errors = get(severitys.ERROR)
    self.warns = get(severitys.WARN)
    self.hints = get(severitys.HINT)
    self.infos = get(severitys.INFO)
    self.icons = icons.diagnostics
  end,

  update = { "DiagnosticChanged", "BufEnter", callback = vim.schedule_wrap(function() vim.cmd "redrawstatus" end) },
  {
    provider = function(self) return self.errors > 0 and (self.icons.Error .. self.errors .. " ") end,
    hl = { fg = "diag_error" },
  },
  {
    provider = function(self) return self.warns > 0 and (self.icons.Warn .. self.warns .. " ") end,
    hl = { fg = "diag_warn" },
  },
  {
    provider = function(self) return self.infos > 0 and (self.icons.Info .. self.infos .. " ") end,
    hl = { fg = "diag_info" },
  },
  {
    provider = function(self) return self.hints > 0 and (self.icons.Hint .. self.hints .. " ") end,
    hl = { fg = "diag_hint" },
  },
  { provider = " " },
}
