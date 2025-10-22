return {
  { provider = "", hl = function(self) return { fg = self.mode_color } end },
  {
    provider = function() return "  " .. os.date "%R " end,
    hl = function(self) return { fg = "dark", bg = self.mode_color } end,
  },
}
