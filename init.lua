-- require "utils.profiler"
require "config.options"
local wait = require "load.packs"
require "load.colorscheme"

vim.api.nvim_create_autocmd("User", {
  pattern = "DeferredUIEnter",
  callback = function()
    require "load.keymap"
    require "config.autocmds"
    require "config.neovide"
  end,
})

wait()
