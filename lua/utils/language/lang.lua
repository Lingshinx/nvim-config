local Lang = {}
local list = require "utils.list"
local append = list.append
local filter = list.filter

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

    config_options = function(self)
      if not self.options then return end
      vim.api.nvim_create_autocmd("FileType", {
        pattern = self.name,
        desc = string.format("Set options for filetype %s", self.name),
        callback = function()
          for opt, value in pairs(self.options) do
            vim.opt_local[opt] = value
          end
        end,
      })
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

---@alias config.language.new fun(name: string, config: config.language.Config):config.language.Langs?

---@type config.language.new
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
  result.options = config.options
  return setmetatable(result, metatable)
end

---@type {new: config.language.new}
return Lang
