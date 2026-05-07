local plug = require("utils.keymaps").config

return {
  "rebelot/heirline.nvim",
  event = "DeferredUIEnter",
  keys = {
    { plug "TabPick", function() require("utils.plugin.heirline.utils").pick() end },
    { plug "TabRename", function() require("utils.plugin.heirline.tabline.name").set() end },
  },
  after = function() require("heirline").setup(require "utils.plugin.heirline") end,
}
