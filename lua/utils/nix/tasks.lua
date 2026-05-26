---@class nix-mason.tasks.Tasks
---@field total integer
---@field done integer
---@field tasks table<integer, {total: integer, done: integer}>
---@field finish fun(self, id: integer)
---@field update fun(self, id: integer, done: integer, total: integer)
---@field percentage fun(self): number

local Tasks = {}

Tasks.__index = Tasks

---@return nix-mason.tasks.Tasks
function Tasks.new()
  return setmetatable({
    total = 0,
    done = 0,
    tasks = {},
  }, Tasks)
end

---@param self nix-mason.tasks.Tasks
---@param id integer
---@param done integer
---@param total integer
function Tasks:update(id, done, total)
  self.total = self.total + total
  self.done = self.done + done
  local current_task = self.tasks[id]
  if current_task then
    self.total = self.total - current_task.total
    self.done = self.done - current_task.done
  end
  self.tasks[id] = { total = total, done = done }
end

---@param self nix-mason.tasks.Tasks
---@param id integer
function Tasks:finish(id)
  local tasks = self.tasks[id]
  if not tasks then return end
  self.done = self.done + tasks.total - tasks.done
  tasks.done = tasks.total
end

---@param self nix-mason.tasks.Tasks
---@return number
function Tasks:percentage()
  local ret = self.total == 0 and 0 or self.done / self.total * 100
  return math.floor(ret)
end

return Tasks
