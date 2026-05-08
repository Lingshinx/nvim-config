vim.pack.add { "https://github.com/lumen-oss/lz.n" }
require("lz.n").register_handler(require "utils.pack.handler.load_before")

local pack = require "utils.pack"
local dir = vim.fn.stdpath "config" .. "/lua/plugins"
local load = require "utils.load"
local signal, wait = load.mk_waiter { timeout = 5000, interval = 500, fast_only = false }
load.ls(dir, {
  recursive = true,
  after = vim.schedule_wrap(function(files)
    for _, file in ipairs(files) do
      pack.add(dofile(file))
    end
    pack.load()
    signal()
  end),
})

return wait
