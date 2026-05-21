---@class nix-mason.log.Opts
---@field interval integer?
---@field on_msg fun(msg: string)
---@field on_tasks fun(tasks: nix-mason.tasks.Tasks)

local M = {}

---@param tasks nix-mason.tasks.Tasks
---@param event {id: integer, type: integer, fields:integer[]}
local function each_event(tasks, event)
  local id = event.id
  if event.type == 105 and event.fields then
    tasks:update(id, event.fields[1], event.fields[2])
    return true
  elseif event.type == 106 then
    tasks:finish(id)
    return true
  end
  return false
end

local function strip_ansi(str) return str:gsub("\x1b%[[0-9;]*m", "") end

---@param opts nix-mason.log.Opts
function M.log(opts)
  local interval = opts and opts.interval or 200
  local tasks = require("utils.nix.tasks").new()
  local last_update_time = 0
  return function(_, data)
    if not data then return end
    for line in data:gmatch "[^\r\n]+" do
      if not line:match "^@nix " then goto continue end

      local json_str = line:sub(6)
      local ok, event = pcall(vim.json.decode, json_str)
      if not (ok and event) then goto continue end

      if event.action == "result" then
        if not each_event(tasks, event) then goto continue end
      elseif event.action == "msg" then
        if opts.on_msg then vim.schedule(function() opts.on_msg(strip_ansi(event.msg)) end) end
      end

      local now = vim.uv.now()
      if now - last_update_time < interval and event.type ~= 106 then goto continue end
      last_update_time = now

      if opts.on_tasks then vim.schedule(function() opts.on_tasks(tasks) end) end
      ::continue::
    end
  end
end

return M
