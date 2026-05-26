---@class config.manager.Spec
---@field before? fun(self: table?)
---@field update? fun(items: string[]?, self: table?)
---@field install? fun(items: string[]?, self: table?)
---@field clean? fun(self: table?)
---@field complete? fun(arg_lead: string?, self: table?): string[]

---@type table<string, config.command.SubcommandOpt|config.command.Subcommand>
local installers = {}
installers.all = function()
  for _, installer in pairs(installers) do
    installer()
  end
end

---@type table<string, config.command.SubcommandOpt|config.command.Subcommand>
local cleaners = {}
cleaners.all = function()
  for _, cleaner in pairs(cleaners) do
    cleaner()
  end
end

---@type table<string, config.command.SubcommandOpt|config.command.Subcommand>
local updaters = {}
updaters.all = function(_, opts)
  if opts.bang then cleaners.all() end
  for _, updater in pairs(updaters) do
    updater()
  end
end

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

local M = {}

M = {
  setup = function()
    M.register(require "utils.manager.default")
    require("utils.command").create("Update", updaters)
    require("utils.command").create("Clean", cleaners)
    require("utils.command").create("Install", installers)
  end,

  register = function(spec)
    for name, manager in pairs(spec) do
      if manager.update then
        updaters[name] = {
          cmd = function(args, opts)
            local self = get(name, manager.before)
            if opts.bang and manager.clean then manager.clean(self) end
            manager.update(args, self)
            set(name)
          end,
          complete = function(arg_lead) return manager.complete(arg_lead, get(name, manager.before)) end,
        }
      end
      if manager.clean then
        cleaners[name] = {
          cmd = function()
            manager.clean(get(name, manager.before))
            set(name)
          end,
        }
      end
      if manager.install then
        installers[name] = {
          cmd = function(args)
            manager.install(args, get(name, manager.before))
            set(name)
          end,
        }
      end
    end
  end,
}

return M
