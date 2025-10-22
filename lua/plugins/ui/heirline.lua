return {
  "rebelot/heirline.nvim",
  event = "VeryLazy",
  config = function() require("heirline").setup(require "utils.plugin.heirline") end,
}
