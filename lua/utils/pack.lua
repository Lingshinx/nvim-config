local M = {}

---@module "lz.n"

---@class utils.pack.Spec
---@field [1]? string
---@field name? string
---@field url? string
---@field main? string
---@field enabled? boolean|fun():boolean
---@field before? fun()
---@field beforeAll? fun()
---@field after? fun()
---@field event? string|string[]
---@field ft? string
---@field cmd? string|string[]
---@field keys? utils.keymap.Mapping
---@field colorscheme? string|string[]
---@field lazy? boolean
---@field priority? number
---@field load? fun(string)?
---@field opts? table
---@field optional? boolean

---@alias utils.pack.Config (string|utils.pack.Spec)[]|utils.pack.Spec

local packs = {}
local lazies = {}
local spec_map = {}

---@param spec utils.pack.Spec
---@return string url, string name
local function parse_pack(spec)
  local url, name
  if spec[1] then
    url = "https://github.com/" .. spec[1]
    name = vim.split(spec[1], "/", { trimempty = true, plain = true })[2]
  end
  if url then
    url = url
    local components = vim.split(url, "/", { trimempty = true, plain = true })
    name = components[#components]
  end
  if name then name = name end
  return url, name
end

local default_loader = vim.g.package_load or vim.g.lz_n or vim.cmd.packadd
---@param spec utils.pack.Spec
local function transform(name, spec)
  spec[1] = name
  spec.url = nil
  spec.name = nil
  spec.after = spec.after or spec.main and spec.opts and function() require(spec.main).setup(spec.opts) end
  spec.load = spec.load or default_loader
  return spec
end

local function get_main(name) return name:lower():gsub("^n?vim%-", ""):gsub("%.n?vim$", "") end

---@param config utils.pack.Config
function M.add(config)
  if type(config) == "string" then
    M.register { config }
  elseif type(config) == "table" then
    if type(config[1]) == "string" then
      M.register(config)
    else
      for _, spec in ipairs(config) do
        if type(spec) == "table" then M.register(spec) end
      end
    end
  end
end

local merge = require("utils.fn").merge

---@param spec utils.pack.Spec
function M.register(spec)
  if spec.enabled == false then return end
  local url, name = parse_pack(spec)
  spec.main = spec.main or get_main(name)
  local config = spec_map[name] or { keys = {}, opts = {} }

  if spec.opts then spec.opts = merge(config.opts, spec.opts) end
  if spec.keys then spec.keys = merge(config.keys, spec.keys) end

  spec_map[name] = config

  if spec.optional then return end

  lazies[#lazies + 1] = transform(name, spec)
end

function M.load()
  vim.pack.add(packs)
  end
  if not vim.tbl_isempty(lazies) then require("lz.n").load(lazies) end
  packs = nil
  lazies = nil
  spec_map = nil
end

return M
