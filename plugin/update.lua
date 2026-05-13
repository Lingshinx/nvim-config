if vim.g.config_manager_loaded then return end
vim.g.config_manager_loaded = true

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
      if opts.bang and manager.clean then manager.clean() end
      manager.update(args, get(name, manager.before))
      set(name)
    end,
    complist = manager.complist and function(arg_lead) return manager.complist(get(name, manager.before), arg_lead) end,
    comp = manager.comp and function(arg_lead) return manager.comp(get(name, manager.before), arg_lead) end,
  }
end

require("utils.command").create("Update", commands)
