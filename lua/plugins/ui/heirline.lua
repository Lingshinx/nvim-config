return {
  "rebelot/heirline.nvim",
  lazy = true,
  event = "DeferredUIEnter",
  after = function() require("heirline").setup(require "utils.plugin.heirline") end,
}
