if vim.g.loadedconfig_manager then return end
vim.g.loaded_config_manager = true

---@type table<string, config.command.SubcommandOpt|config.command.Subcommand>
local commands = {
  all = function(_, opts)
    local bang = opts.bang
    for _, manager in pairs(require "utils.manager") do
      if manager.clean and bang then manager.clean() end
      manager.update()
    end
  end,
}

local init = {}

local function get(name, before)
  if before and not init[name] then
    local self = {}
    before(self)
    init[name] = self
  end
  return init[name]
end

local function set(name) init[name] = nil end

for name, manager in pairs(require "utils.manager") do
  commands[name] = {
    cmd = function(args, opts)
      local self = get(name, manager.before)
      if opts.bang and manager.clean then manager.clean(self) end
      manager.update(args, self)
      set(name)
    end,
    complete = function(arg_lead) return manager.complete(arg_lead, get(name, manager.before)) end,
  }
end

require("utils.command").create("Update", commands)
