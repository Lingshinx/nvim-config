local Lang = require "utils.language.lang"
local append = require("utils.list").append
local mapfold = require("utils.list").mapfold

local properties = {
  formatters = function(result, config) result[config.name] = config.formatter end,
  plugins = function(result, config) append(result, config.plugins) end,
  treesitter = function(result, config) vim.list_extend(result, config.treesitter or {}) end,
  lsp = function(result, config) append(result, config.lsp) end,
  mason = function(result, config)
    vim.list_extend(result, config:get_lspnames() or {})
    vim.list_extend(result, config.formatter or {})
    vim.list_extend(result, config.pkgs or {})
  end,
}

---@alias config.language.Collect fun(lang:config.language.Langs, callback: fun(result:table, config:config.language.Langs)):table
local lang_functions = {
  ---@param langs config.language.Langs
  ---@param config config.language.Config
  ---@param name string
  append = function(langs, name, config) langs.get[name] = Lang.new(name, config) end,

  config_lsp = function(langs)
    for _, config in pairs(langs.get) do
      config:config_lsp()
    end
  end,

  config_options = function(langs)
    for _, config in pairs(langs.get) do
      config:config_options()
    end
  end,

  config_mason = function(langs)
    for _, pkg in ipairs(langs.mason) do
      require("utils.plugin.mason").install(pkg)
    end
  end,

  config_treesitter = function(langs)
    require("utils.plugin.treesitter").ensure_installed(langs.treesitter)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = langs.treesitter,
      callback = function()
        vim.treesitter.start()
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo.foldmethod = "expr"
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,

  config_formatter = function(langs)
    local conform = require "conform"
    conform.formatters_by_ft = vim.tbl_extend("force", conform.formatters_by_ft, langs.formatters)
  end,

  config = function(langs, opts)
    langs.ok = true
    if opts then
      for _, v in ipairs(opts) do
        langs["config_" .. v](langs)
      end
      return
    end
    langs:config_options()
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

  ---@type config.language.Collect
  collect = function(langs, callback)
    vim.wait(1000, function() return langs.ok end)
    return mapfold({}, callback, langs.get)
  end,
}

local metatable = {
  __index = function(self, key)
    local result = properties[key]
    return result and self:collect(result) or lang_functions[key]
  end,
}

---@type {new: fun():config.language.Langs; config:fun(config.language.Langs)}
return {
  new = function()
    return setmetatable({
      get = {},
    }, metatable)
  end,
}
