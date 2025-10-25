local conditions = require "heirline.conditions"

local Mode = {
  update = {
    "ModeChanged",
    pattern = "*:*",
    callback = vim.schedule_wrap(function() vim.cmd "redrawstatus" end),
  },
  {
    provider = function(self) return " " .. self.mode_names[self.mode] .. " " end,
    hl = function(self) return { fg = "dark", bg = self.mode_colors[self.mode] } end,
    static = {
      mode_names = {
        n = "NORMAL",
        i = "INSERT",
        c = "COMMAND",
        v = "VISUAL",
        V = "V-LINE",
        ["\22"] = "V-BLOCK",
        s = "SELECT",
        S = "S-LINE",
        ["\19"] = "S-BLOCK",
        R = "REPLACE",
        r = "WAITING",
        ["!"] = "RUNNING",
        t = "TERMINAL",
      },
    },
  },
  { provider = " ", hl = function(self) return { fg = self.mode_color } end },
}

return {
  fallthrough = false,
  {
    condition = conditions.is_git_repo,
    update = { "BufEnter", "ModeChanged" },
    {
      Mode,
      {
        provider = function() return " " .. vim.b.gitsigns_status_dict.head .. " " end,
      },
      hl = function(self) return { fg = self.mode_color, bg = "bright_bg" } end,
    },
    { provider = " ", hl = { fg = "bright_bg" } },
  },
  Mode,
}
