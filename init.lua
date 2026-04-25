-- require "utils.profiler"
require "config.options"
local wait_plugins = require "load.packs"
require "load.langs"
require "load.colorscheme"

vim.api.nvim_create_autocmd("User", {
  pattern = "DeferredUIEnter",
  callback = function()
    require "load.keymap"
    require "config.autocmds"
    require "config.neovide"
  end,
})

wait_plugins()
