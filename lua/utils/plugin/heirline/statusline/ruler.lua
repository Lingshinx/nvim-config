return {
  { provider = " ", hl = { fg = "bright_bg" } },
  {
    hl = function(self) return { bg = "bright_bg", fg = self.mode_color } end,
    provider = "%3l:%-3c",
    require "utils.plugin.heirline.statusline.clock",
  },
}
