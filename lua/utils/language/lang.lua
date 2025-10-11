local Lang = {}
local append = require("utils.list").append

---@module 'lazy'

local metatable = {
  __index = {
    set_treesitter = function(self, treesitter)
      if type(treesitter) == "table" then
        self.treesitter = treesitter
      elseif type(treesitter) == "string" then
        self.treesitter = { treesitter }
      elseif treesitter ~= false then
        self.treesitter = { self.name }
      end
    end,

    set_formatter = function(self, formatter)
      if type(formatter) == "table" then
        self.formatter = formatter
      elseif type(formatter) == "string" then
        self.formatter = { formatter }
      end
    end,

    config_lsp = function(self)
      local lsp = self.lsp
      if type(lsp) == "string" then
        vim.lsp.enable(lsp)
      elseif type(lsp) == "table" then
        for k, v in pairs(lsp) do
          if type(k) == "number" then
            vim.lsp.enable(v)
          else
            vim.lsp.config(k, v)
            vim.lsp.enable(k)
          end
        end
      end
    end,

    get_lspnames = function(self)
      local lsp = self.lsp
      if type(self.lsp) == "string" then
        return { lsp }
      elseif type(lsp) == "table" then
        local result = {}
        for k, v in pairs(lsp) do
          if type(k) == "number" then
            append(result, v)
          else
            append(result, k)
          end
        end
        return result
      end
    end,
  },
}

---@alias Config.Lang.New fun(name: string, config: Config.LangConfig):Config.Lang?

---@type Config.Lang.New
function Lang.new(name, config)
  if not config or config.enabled == false then return end
  local result = setmetatable({
    name = name,
  }, metatable)
  result:set_treesitter(config.treesitter)
  result:set_formatter(config.formatter)
  result.lsp = config.lsp
  result.plugins = config.plugins
  result.pkgs = config.pkgs
  return setmetatable(result, metatable)
end

---@type {new: Config.Lang.New}
return Lang
