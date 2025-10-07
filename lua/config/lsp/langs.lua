local Lang = require "config.lsp.lang"
local append = require("config.utils.list").append
local mapfold = require("config.utils.list").mapfold

---@alias Config.Langs.Collect fun(lang:Config.Langs, callback: fun(result:table, config:Config.Langs)):table

---@class Config.Langs
---@field get table<string,Config.Lang>
---@field formatters table<string,string[]>
---@field lsp (string|table<string,table>)[]
---@field mason string[]
---@field treesitter string[]
---@field plugins LazySpec
---@field append fun(langs: Config.Langs, name:string, config: Config.LangConfig)
---@field config fun()

local metatable = {
  __index = function(self, key)
    local result = ({
      formatters = function(result, config) result[config.name] = config.formatter end,
      plugins = function(result, config) append(result, config.plugins) end,
      treesitter = function(result, config) vim.list_extend(result, config.treesitter or {}) end,
      lsp = function(result, config) append(result, config.lsp) end,
      mason = function(result, config)
        vim.list_extend(result, config:get_lspnames() or {})
        vim.list_extend(result, config.formatter or {})
      end,
    })[key]
    return result and self:collect(result)
      or ({
        ---@param langs Config.Langs
        ---@param config Config.LangConfig
        ---@param name string
        append = function(langs, name, config) langs.get[name] = Lang.new(name, config) end,

        config = function(langs)
          for _, config in pairs(langs.get) do
            config:config_lsp()
          end
        end,

        ---@type Config.Langs.Collect
        collect = function(langs, callback) return mapfold({}, callback, langs.get) end,
      })[key]
  end,
}

---@type {new: fun():Config.Langs; config:fun(Config.Langs)}
return {
  new = function()
    return setmetatable({
      get = {},
    }, metatable)
  end,
}
