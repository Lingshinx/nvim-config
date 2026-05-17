local M = {}

---@module "lz.n"

---@class utils.pack.Spec
---@field [1]? string
---@field name? string
---@field url? string
---@field dir? string
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
---@field load_before? any

---@alias utils.pack.Config (string|utils.pack.Spec)[]|utils.pack.Spec

local spec_map = {}

---@param spec utils.pack.Spec
---@return string url, string name, string? version
local function parse_pack(spec)
  local url, name, version
  if spec.dir then spec.url = "file://" .. vim.fs.normalize(spec.dir) end
  if spec.url then
    url = spec.url --[[@as string]]
    local components = vim.split(url:gsub("%a+://", ""), "/", { trimempty = true, plain = true })
    name = components[#components]
  elseif spec[1] then
    local components = vim.split(spec[1], "/", { trimempty = true, plain = true })
    url = "https://github.com/" .. components[1] .. "/" .. components[2]
    name, version = components[2], components[3]
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
    if type(config[1]) == "string" or not config[1] then
      M.register(config)
    else
      for _, spec in ipairs(config) do
        if type(spec) == "table" then M.register(spec) end
      end
    end
  end
end

local merge = require("utils.fn").merge

local function list_extend(left, right)
  if type(left) ~= "table" then left = { left } end
  if type(right) ~= "table" then
    left[#left + 1] = right
  else
    local length = #left
    for index, value in ipairs(right) do
      left[length + index] = value
    end
  end
  return left
end

local list_field = { "event", "keys", "load_before", "cmd" }
local keep_field = { "before", "beforeAll", "after", "lazy" }

---@param left utils.pack.Spec
---@param right utils.pack.Spec
---@return utils.pack.Spec
local function merge_spec(left, right)
  for _, field in ipairs(list_field) do
    if right[field] then left[field] = list_extend(left[field], right[field]) end
  end
  for _, field in ipairs(keep_field) do
    if left[field] == nil and right[field] ~= nil then left[field] = right[field] end
  end
  if right.opts then left.opts = left.opts and merge(left.opts, right.opts) or right.opts end
  return left
end

---@param spec utils.pack.Spec
function M.register(spec)
  if spec.loaded or spec.enabled == false then return end
  spec.loaded = true

  local url, name, version = parse_pack(spec)

  spec.main = spec.main or get_main(name)
  spec.url = url
  spec.name = name
  spec.version = version

  if spec_map[name] then
    spec_map[name] = merge_spec(spec_map[name], spec)
  else
    spec_map[name] = spec
  end
end

function M.load()
  vim.pack.add(
    vim
      .iter(pairs(spec_map))
      :map(function(name, spec) return { src = spec.url, name = name, version = spec.version } end)
      :totable(),
    { load = function() end }
  )
  require("lz.n").load(vim.iter(pairs(spec_map)):map(transform):totable())
  spec_map = nil
end

---@param name string
---@param callback fun(...)
function M.after(name, callback, ...)
  local pack = require("lz.n").lookup(name)
  if not pack then
    callback(...)
  else
    local args = select("#", ...) > 0 and { ... }
    local old_after = pack.after
    if old_after then
      pack.after = function()
        old_after(pack)
        callback(args and unpack(args))
      end
    else
      pack.after = args and function() callback(unpack(args)) end or callback
    end
  end
end

---@param name string
---@param callback fun(...)
function M.after_wrap(name, callback)
  return function(...) M.after(name, callback, ...) end
end

return M
