local M = {}

---@module "lz.n"

---@class utils.pack.Spec
---@field [1]? string
---@field name? string
---@field url? string
---@field version? string
---@field main? string
---@field enabled? boolean|fun():boolean
---@field loaded? boolean
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
---@return string url, string name, string? version
local function parse_pack(spec)
  local url, name, version
  if spec[1] then
    local components = vim.split(spec[1], "/", { trimempty = true, plain = true })
    url = "https://github.com/" .. components[1] .. "/" .. components[2]
    name, version = components[2], components[3]
  else
    local spec_url = spec.url
    if spec_url then
      url = spec_url
      local components = vim.split(url:gsub("%a+://", ""), "/", { trimempty = true, plain = true })
      name, version = components[2], components[3]
    end
  end
  if spec.name then name = spec.name end
  if spec.version then version = spec.version end
  if url == nil then error(("url not specified in %s"):format(vim.inspect(spec))) end
  if name == nil then error(("name not specified in %s"):format(vim.inspect(spec))) end
  return url, name, version
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
  if spec.loaded or spec.enabled == false then return end
  spec.loaded = true

  local url, name, version = parse_pack(spec)
  if packs[name] and not spec.optional then return end

  spec.main = spec.main or get_main(name)

  local config = spec_map[name] or { keys = {}, opts = {} }
  if spec.opts then spec.opts = merge(config.opts, spec.opts) end
  if spec.keys then spec.keys = merge(config.keys, spec.keys) end
  spec_map[name] = config

  if spec.optional then return end
  packs[name] = { src = url, name = name, version = version }

  lazies[#lazies + 1] = transform(name, spec)
end

---@param name string
---@param callback fun(...)
function M.after(name, callback, ...)
  local pack = require("lz.n").lookup(name)
  if not pack then
    callback(...)
  else
    local args = { ... }
    local old_after = pack.after
    if old_after then pack.after = function()
      old_after(pack)
      callback(unpack(args))
    end end
  end
end

---@param name string
---@param callback fun(...)
function M.after_wrap(name, callback)
  return function(...) M.after(name, callback, ...) end
end

function M.load()
  local pkgs = {}
  for _, pkg in pairs(packs) do
    pkgs[#pkgs + 1] = pkg
  end
  vim.pack.add(pkgs)
  if not vim.tbl_isempty(lazies) then require("lz.n").load(lazies) end
  packs = nil
  lazies = nil
  spec_map = nil
end

return M
