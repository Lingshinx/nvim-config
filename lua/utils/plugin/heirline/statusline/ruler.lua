return {
  { provider = " ", hl = { fg = "bright_bg" } },
  {
    hl = function(self) return { bg = "bright_bg", fg = self.mode_color } end,
    {
      fallthrough = false,
      {
        condition = function(self) return self.mode:match "[vV\22]" end,
        provider = function(self)
          local mode = self.mode
          local range = require("utils.edit").visual_range()
          if mode == "v" then return string.format("%3s:%-3s", range.rows, range.length) end
          if mode == "\22" then return string.format("%3s:%-3s", range.rows, range.columns) end
          if mode == "V" then
            local cur_row = unpack(vim.api.nvim_win_get_cursor(0))
            local length = #vim.trim(vim.api.nvim_buf_get_lines(0, cur_row - 1, cur_row, true)[1])
            return string.format("%3s:%-3s", range.rows, length)
          end
          return ""
        end,
      },
      {
        provider = "%3l:%-3c",
      },
    },
    require "utils.plugin.heirline.statusline.clock",
  },
}
