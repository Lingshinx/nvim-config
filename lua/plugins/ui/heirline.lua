return {
  "rebelot/heirline.nvim",
  event = "DeferredUIEnter",
  after = function() require("heirline").setup(require "utils.plugin.heirline") end,
}
