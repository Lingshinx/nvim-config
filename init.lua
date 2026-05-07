-- require "utils.profiler"
require "config.options"
local wait = require "load.packs"
local langs = require "load.langs"
require "load.colorscheme"

vim.api.nvim_create_autocmd("User", {
  pattern = "DeferredUIEnter",
  callback = function()
    langs:load()
    require "load.keymap"
    require "config.autocmds"
    require "config.neovide"
  end,
})

wait()
