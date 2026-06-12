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

---@return boolean
local function start_with_buf()
  if vim.fn.argc(-1) ~= 0 then return true end
  if vim.list_contains(vim.v.argv, "-c") then return true end
  local buf = 1
  local uis = vim.api.nvim_list_uis()
  if #uis == 0 then return true end
  if uis[1].stdout_tty and not uis[1].stdin_tty then return true end
  if vim.api.nvim_buf_line_count(buf) > 1 or #(vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or "") > 0 then
    return true
  end
end

return {
  merge = merge,

  contains_map = contains_map,

  start_with_buf = start_with_buf,

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
