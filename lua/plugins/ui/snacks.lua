local function pick(cmd)
  return function() Snacks.dashboard.pick(cmd) end
end
local function pickfiles(cwd)
  return function() Snacks.dashboard.pick("files", { cwd = cwd }) end
end
local utils = require "utils.plugin.dashboard"
local make_side_panel = utils.make_side_panel
local notification = utils.notification
local header = { section = "header" }
local keys = { section = "keys", gap = 1, indent = 2, padding = 1 }
local startup = { section = "startup", indent = 2, padding = 1, pane = 2 }
local gh_notify = make_side_panel {
  title = "Notification",
  icon = "󰊤",
  notification(),
}

local project = make_side_panel {
  section = "projects",
  title = "Projects",
  icon = "",
}

local recent = make_side_panel {
  section = "recent_files",
  title = "Recents",
  icon = "",
}

local config_dir = vim.fn.stdpath "config"
local dot_dir = vim.env.XDG_CONFIG_HOME or "~/.config"
local logo = [[
         ████                                             
        ██  ──聆噺讨厌写代码─󰫢─ █                    
    𓇼  ██                 ████ █  ⟡                   
      ██ ██ ████ █████ █     ██████ ██     
     ██ ██ ████ ████████████ █ ████      
    ██ ██ ████ █ █ █  █ █ ████      ⟡ 
  ████████████ ████████████ ████████ ████       
                        █                                 
          ███████████████       ⛧                         
]]
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    dashboard = {
      ---@type snacks.dashboard.Section
      sections = function(self)
        local win_width = vim.api.nvim_win_get_width(self.win)
        local pane_gap = self.opts.pane_gap
        local item_width = self.opts.width
        local max_panes = math.floor((win_width + pane_gap) / (item_width + pane_gap))
        return {
          header,
          max_panes > 1 and {
            gh_notify,
            project,
            recent,
          },
          keys,
          startup,
        }
      end,
      preset = {
        header = logo,
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = pick "files" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "r", desc = "Recent Files", action = pick "oldfiles" },
          { icon = " ", key = ".", desc = "Dot Files", action = pickfiles(dot_dir) },
          { icon = " ", key = "c", desc = "Config", action = pickfiles(config_dir) },
          { icon = " ", key = "z", desc = "Zettle Kastle", action = ":ZkNotes" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
    },
  },
}
