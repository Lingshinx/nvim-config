---@param a table
---@param b table
---@return table c
local function merge(a, b)
  for key, value in pairs(b) do
    if type(a[key]) == "table" and type(value) == "table" then
      merge(a[key], value)
    else
      a[key] = value
    end
  end
  return a
end

---@param list any[]
---@return table<any,boolean>
local function contains_map(list)
  local ret = {}
  for _, it in ipairs(list) do
    ret[it] = true
  end
  return ret
end

local M = {}
M = {
  merge = merge,

  contains_map = contains_map,

  ---@param str string
  ---@return string
  capitalize = function(str) return str:sub(1, 1):upper() .. str:sub(2) end,

  ---@param str string
  ---@param length integer
  ---@param tail string
  truncate = function(str, length, tail)
    if #str <= length then return str end
    return str:sub(1, length - #tail) .. tail
  end,
}
return M
