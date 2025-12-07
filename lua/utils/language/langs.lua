local Lang = require "utils.language.lang"
local append = require("utils.list").append
local mapfold = require("utils.list").mapfold

---@alias Config.Langs.Collect fun(lang:Config.Langs, callback: fun(result:table, config:Config.Langs)):table

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
        vim.list_extend(result, config.pkgs or {})
      end,
    })[key]
    return result and self:collect(result)
      or ({
        ---@param langs Config.Langs
        ---@param config Config.LangConfig
        ---@param name string
        append = function(langs, name, config) langs.get[name] = Lang.new(name, config) end,

        config_lsp = function(langs)
          for _, config in pairs(langs.get) do
            config:config_lsp()
          end
        end,

        config_mason = function(langs)
          for _, pkg in ipairs(langs.mason) do
            require("utils.plugin.mason").install(pkg)
          end
        end,

        config_treesitter = function(langs) require("nvim-treesitter.install").ensure_installed(langs.treesitter) end,

        config_formatter = function(langs)
          local conform = require "conform"
          conform.formatters_by_ft = vim.tbl_extend("force", conform.formatters_by_ft, langs.formatters)
        end,

        config = function(langs)
          langs:config_lsp()
          langs:config_mason()
          langs:config_treesitter()
          langs:config_formatter()
        end,

        solve = function(langs, mod)
          local mt = { __index = mod }
          for _, lang in ipairs(mod) do
            if type(lang) == "string" then
              langs:append(lang, mod)
            elseif type(lang) == "table" then
              langs:solve(setmetatable(lang, mt))
            end
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
