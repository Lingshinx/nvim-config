local function load_treesitter()
  if not package.loaded["nvim-treesitter"] then require("lz.n").trigger_load "nvim-treesitter" end
  return require "nvim-treesitter"
end

---@type table<string, config.manager.Spec>
local managers = {
  treesitter = {
    before = function(self) self.treesitter = load_treesitter() end,
    update = function(languages, self) self.treesitter.update(languages) end,
    clean = function(self)
      local treesitter = self.treesitter
      local neededs = require("utils.fn").contains_map(require("load.langs").treesitter)
      local unneededs = vim
        .iter(treesitter().get_installed())
        :filter(function(parser) return not neededs[parser] end)
        :totable()
      treesitter.uninstall(unneededs)
    end,
    complete = function(_, self) return self.treesitter.get_installed() end,
  },

  plugin = {
    update = function(names)
      if not names or vim.tbl_isempty(names) then
        names = vim.iter(vim.pack.get()):map(function(pack) return pack.spec.name end):totable()
      end
      vim.pack.update(names)
    end,
    clean = function()
      local inactives = vim
        .iter(vim.pack.get())
        :filter(function(pack) return not pack.active end)
        :map(function(pack) return pack.spec.name end)
        :totable()
      vim.pack.del(inactives)
    end,
    complete = function()
      return vim.iter(vim.pack.get()):map(function(pack) return pack.spec.name end):totable()
    end,
  },
}

return managers
