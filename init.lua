-- require "utils.profiler"
require "config.options"
require "config.lazy"

require("utils.fn").deter(function()
  require "config.keymaps"
  require "config.autocmds"
  require "config.highlight"
  require "config.neovide"
end)
