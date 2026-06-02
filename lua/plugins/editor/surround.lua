local map = require "utils.keymaps"
local plug = map.plug

return {
  "kylechui/nvim-surround",
  keys = {
    { "sa", plug "nvim-surround-normal", desc = "Add surrounding" },
    { "sA", plug "nvim-surround-normal-line", desc = "Add surrounding on new lines" },
    { "ssa", plug "nvim-surround-normal-cur", desc = "Add surrounding arround current line" },
    { "sao", plug "nvim-surround-normal-cur-line", desc = "Add surrounding arround current line on new line" },

    { "sa", plug "nvim-surround-visual", mode = "x", desc = "Add surrounding" },
    { "sA", plug "nvim-surround-visual-line", mode = "x", desc = "Add surrounding on new lines" },

    { "sd", plug "nvim-surround-delete", desc = "Delete surrounding" },
    { "sr", plug "nvim-surround-change", desc = "Replace surrounding" },
    { "sR", plug "nvim-surround-change-line", desc = "Replace surrounding on new lines" },
  },
  before = function() vim.g.nvim_surround_no_mappings = true end,
}
