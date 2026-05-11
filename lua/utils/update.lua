local M = {}

local updaters = {}

function updaters.plugins()
  local inactives = vim
    .iter(vim.pack.get())
    :filter(function(pack) return not pack.active end)
    :map(function(pack) return pack.spec.name end)
    :totable()
  vim.pack.del(inactives)
  vim.pack.update()
end

function updaters.treesitter()
  if not package.loaded["nvim-treesitter"] then require("lz.n").trigger_load "nvim-treesitter" end
  require("nvim-treesitter").update()
end

function M.update(name)
  if name then
    local updater = updaters[name]
    if not updater then error("no updater called " .. name, vim.log.levels.ERROR) end
    updater()
  else
    for _, value in pairs(updaters) do
      value()
    end
  end
end

M.updaters = updaters

return M
