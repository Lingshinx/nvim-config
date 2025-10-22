local icon = require "config.icons"
local conditions = require "heirline.conditions"

return {
  condition = conditions.is_git_repo,

  init = function(self)
    self.diff_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.diff_dict
      and self.diff_dict.added
      and (self.diff_dict.added ~= 0 or self.diff_dict.removed ~= 0 or self.diff_dict.changed ~= 0)
  end,

  flexible = 4,

  {
    {
      provider = " ",
      condition = function(self) return self.has_changes and (self.has_command or self.has_mode) end,
    },

    {
      condition = function(self) return self.has_changes end,
      unpack(vim.tbl_map(function(sign)
        return {
          condition = function(self) return self.diff_dict[sign] ~= 0 end,
          provider = function(self) return " " .. icon.git[sign] .. self.diff_dict[sign] end,
          hl = { fg = "git_" .. sign },
        }
      end, {
        "added",
        "changed",
        "removed",
      })),
    },
  },
  {},
}
