---@class utils.language.TypedExtractor
---@field string? boolean | fun(property:string, name:string, lang: table):any
---@field boolean? boolean | fun(property:boolean, name:string, lang: table):any
---@field t? boolean | fun(name: string, lang: table):any
---@field f? boolean | fun(name: string, lang: table):any
---@field table? boolean | fun(property: table, name: string, lang: table):any
---@field pair? fun(key: any, value: any, name: string, lang: table):any -- because pair == true is equal to table = true
---@field spair? fun(key: string, value: any, name: string, lang: table):any
---@field ipair? fun(index: number, value: any, name: string, lang: table):any

---@generic T,U
---@class utils.language.Property
---@field extract? utils.language.TypedExtractor | boolean | fun(property:any, name: string, lang: table):T?
---@field collect? string | fun(accumulate:any,property:any, name: string, lang: table):T?
---@field load? fun(lang: utils.language.Langs)
---@field default any
---@field each? fun(property:any, name: string ,lang: table)

---@alias utils.language.Properties table<string, utils.language.Property>

---@class utils.language.Langs
---@field properties utils.language.Properties
---@field data table<string,table<string,any>>
---@field new fun(opts: utils.language.Properties)
---@field solve fun(self:self, spec:table)
---@field extract fun(self:self, name:string, spec:table)
---@field fold fun(self:self, property: string, fold: fun(acc, cur):any, init:any?):any
---@field load fun(self:self)
---@field [string] any

local Langs = {}
Langs.__index = Langs ---@diagnostic disable-line

---@param properties utils.language.Properties?
---@return utils.language.Langs
function Langs.new(properties)
  local self = {
    data = {},
    properties = vim.tbl_deep_extend("force", require "utils.language.properties", properties or {}),
  }
  for property, handler in pairs(self.properties) do
    if handler.collect then self[property] = {} end
  end
  return setmetatable(self, Langs)
end

---@param extractor boolean|fun(property, name:string, lang: table)
---@param property any
---@param lang table
---@return any?
local function extract(extractor, property, name, lang)
  if type(extractor) == "boolean" and extractor then return property end
  if type(extractor) == "function" then return extractor(property, name, lang) end
end

---@param extractor utils.language.TypedExtractor
---@param property any
---@param name string
---@param lang table
local function extract_by_table(extractor, property, name, lang)
  local property_type = type(property)
  if property_type == "string" then
    return extract(extractor.string, property, name, lang)
  elseif property_type == "boolean" then
    if extractor.t and property then return type(extractor.t) == "function" and extractor.t(name, lang) or property end
    if extractor.f and not property then
      return type(extractor.t) == "function" and extractor.f(name, lang) or property
    end
    return extract(extractor.boolean, property, name, lang)
  elseif property_type == "table" then
    if extractor.pair then
      return vim.iter(pairs(property)):map(function(k, v) return extractor.pair(k, v, name, lang) end):totable()
    end
    if extractor.spair and extractor.ipair then
      return vim
        .iter(pairs(property))
        :map(
          function(k, v)
            return type(k) == "number" and extractor.ipair(k, v, name, lang) or extractor.spair(k, v, name, lang)
          end
        )
        :totable()
    end
    if extractor.spair then
      return vim
        .iter(pairs(property))
        :map(function(k, v) return type(k) == "string" and extractor.spair(k, v, name, lang) or nil end)
        :totable()
    end
    if extractor.ipair then
      return vim
        .iter(pairs(property))
        :map(function(k, v) return type(k) == "number" and extractor.ipair(k, v, name, lang) or nil end)
        :totable()
    end
    return extract(extractor.table, property, name, lang)
  end
end

---@param name string
---@param self utils.language.Langs
---@param spec table
function Langs:extract(name, spec)
  local extracted = {}
  local properties = self.properties
  for property, handler in pairs(self.properties) do
    if handler.default and spec[property] == nil then spec[property] = handler.default end
  end
  for property, value in pairs(spec) do
    local handler = properties[property]
    if not handler then goto continue end
    local extractor = handler.extract
    if extractor then
      if type(extractor) == "boolean" and extractor then
        extracted[property] = value
      elseif type(extractor) == "function" then
        extracted[property] = extractor(value, name, spec)
      elseif type(extractor) == "table" then
        extracted[property] = extract_by_table(extractor, value, name, spec)
      end
    end
    local collector = handler.collect
    if not collector then goto continue end
    if type(collector) == "function" then
      collector(self[property], value, name, spec)
    elseif type(collector) == "string" then
      if collector == "table" then
        vim.tbl_extend("force", self[property], value)
      elseif collector == "list" then
        if type(value) ~= "table" then
          vim.list_extend(self[property], value)
        else
          table.insert(self[property], value)
        end
      end
    end
    ::continue::
  end

  return extracted
end

---@param self utils.language.Langs
---@param spec table
function Langs:solve(spec)
  local mt = { __index = spec }
  for _, lang in ipairs(spec) do
    if type(lang) == "string" then
      self.data[lang] = self:extract(lang, spec)
    elseif type(lang) == "table" then
      self:solve(setmetatable(lang, mt))
    end
  end
end

---@param property string
---@param fold fun(acc, cur)
---@param init any
function Langs:fold(property, fold, init)
  local acc = init or {}
  for _, lang in pairs(self.data) do
    local cur = lang[property]
    if cur then acc = fold(acc, cur) end
  end
  return acc
end

---@param self utils.language.Langs
function Langs:load()
  for property, collector in pairs(self.properties) do
    if collector.load then collector.load(self) end
    if collector.each then
      for name, lang in pairs(self.data) do
        if lang[property] then collector.each(lang[property], name, lang) end
      end
    end
  end
end

return Langs
