local function pick(cmd)
  return function() Snacks.dashboard.pick(cmd) end
end
local function pickfiles(cwd)
  return function() Snacks.dashboard.pick("files", { cwd = cwd }) end
end
local utils = require "utils.plugin.dashboard"
local make_side_panel = utils.make_side_panel
local notification = utils.notification

local config_dir = vim.fn.stdpath "config"
local dot_dir = vim.env.XDG_CONFIG_HOME or "~/.config"

local logos = require "config.logo"
local logo = vim.g.header and logos[vim.g.header] or logos.lingshin

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    dashboard = {
      ---@type snacks.dashboard.Section
      sections = {
        { section = "header" },
        make_side_panel {
          title = "Notification",
          icon = "󰊤",
          notification(),
        },
        make_side_panel {
          section = "projects",
          title = "Projects",
          icon = "",
        },
        make_side_panel {
          section = "recent_files",
          title = "Recents",
          icon = "",
        },
        { section = "keys", gap = 1, indent = 2, padding = 1 },
        { section = "startup", indent = 2, padding = 1, pane = 2 },
      },
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
