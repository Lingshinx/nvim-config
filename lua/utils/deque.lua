---@generic T
---@class utils.Deque
---@field data [T]
---@field first integer
---@field last integer
---@field head fun(self: utils.Deque): T | nil
---@field tail fun(self: utils.Deque): T | nil
---@field push_end fun(self: utils.Deque, value: T)
---@field concat fun(self: utils.Deque, list: [T])
---@field push_front fun(self: utils.Deque, value: T)
---@field pop_end fun(self: utils.Deque): T | nil
---@field pop_front fun(self: utils.Deque): T | nil
---@field count fun(self: utils.Deque): integer
---@field empty fun(self: utils.Deque): boolean
---@field clear fun(self: utils.Deque)

local Deque = {}
Deque.__index = Deque

---@generic T
---@param table [T]
---@return utils.Deque<T>
function Deque.new(table)
  return table and setmetatable({ data = table, first = 1, last = #table + 1 }, Deque)
    or setmetatable({ data = {}, first = 1, last = 1 }, Deque)
end

---@generic T
---@param self utils.Deque<T>
---@return T
function Deque:head() return self.data[self.first] end

---@generic T
---@param self utils.Deque<T>
---@return T
function Deque:tail() return self.data[self.last - 1] end

---@generic T
---@param self utils.Deque<T>
---@param value T
function Deque:push_end(value)
  local last = self.last
  self.data[last] = value
  self.last = last + 1
end

---@generic T
---@param self utils.Deque<T>
---@param list [T]
function Deque:concat(list)
  local last = self.last
  vim.list_extend(self.data, list)
  self.last = last + #list
end

---@generic T
---@param self utils.Deque<T>
---@param value T
function Deque:push_front(value)
  local new_first = self.first - 1
  self.first = new_first
  self.data[new_first] = value
end

---@generic T
---@param self utils.Deque<T>
---@return T|nil
function Deque:pop_end()
  if self.first == self.last then return end
  local new_last = self.last - 1
  local value = self.data[new_last]
  self.data[new_last] = nil
  self.last = new_last
  if self.first == new_last then
    self.first = 1
    self.last = 1
  end
  return value
end

---@generic T
---@param self utils.Deque<T>
---@return T|nil
function Deque:pop_front()
  local first = self.first
  if first == self.last then return end
  local value = self.data[first]
  self.data[first] = nil
  self.first = first + 1
  if self.first == self.last then
    self.first = 1
    self.last = 1
  end
  return value
end

---@param self utils.Deque
function Deque:count() return self.last - self.first end
---
---@param self utils.Deque
function Deque:empty() return self.first == self.last end

---@param self utils.Deque
function Deque:clear()
  self.data = {}
  self.first = 1
  self.last = 1
end

return Deque
