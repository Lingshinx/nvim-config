local updaters = {}
local cleaners = {}

function cleaners.plugins()
  local inactives = vim
    .iter(vim.pack.get())
    :filter(function(pack) return not pack.active end)
    :map(function(pack) return pack.spec.name end)
    :totable()
  vim.pack.del(inactives)
end

---@param names string[]
function updaters.plugins(names) vim.pack.update(names) end

local function load_treesitter()
  if not package.loaded["nvim-treesitter"] then require("lz.n").trigger_load "nvim-treesitter" end
  return require "nvim-treesitter"
end

function cleaners.treesitter()
  local treesitter = load_treesitter()
  local neededs = require("utils.fn").contains_map(require("load.langs").treesitter)
  local unneededs = vim
    .iter(treesitter().get_installed())
    :filter(function(parser) return not neededs[parser] end)
    :totable()
  treesitter.uninstall(unneededs)
end

---@param languages string|string[]
function updaters.treesitter(languages)
  load_treesitter()
  require("nvim-treesitter").update(languages)
end

function updaters.all()
  for _, value in pairs(updaters) do
    value()
  end
end

function cleaners.all()
  for _, value in pairs(cleaners) do
    value()
  end
end

return {
  update = updaters,
  clean = cleaners,
}
