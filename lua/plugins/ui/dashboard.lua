local keymap = require "utils.keymaps"
local pick, file = keymap.pick, keymap.file
local utils = require "utils.plugin.dashboard"
local make_side_panel = utils.make_side_panel
local notification = utils.notification
local header = { section = "header" }
local keys = { section = "keys", gap = 1, indent = 2, padding = 1 }
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
local startup

vim.api.nvim_create_autocmd("User", {
  pattern = "DeferredUIEnter",
  once = true,
  callback = function()
    local pack = require "utils.pack"
    startup = {
      align = "center",
      indent = 2,
      padding = 1,
      pane = 2,
      text = {
        { "⚡ " .. "Neovim loaded ", hl = "footer" },
        { tostring(pack.count), hl = "special" },
        { " plugins in ", hl = "footer" },
        { ("%.2f ms"):format(vim.g.config_startuptime), hl = "special" },
      },
    }
  end,
})

local config_dir = vim.fn.stdpath "config"
local dot_dir = vim.env.XDG_CONFIG_HOME or "~/.config"

local logos = require "config.logo"
local logo = logos[vim.g.config_header] or logos.lingshin

return {
  "folke/snacks.nvim",
  optional = true,
  opts = {
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
          { icon = " ", key = "r", desc = "Recent Files", action = pick "recent" },
          { icon = " ", key = ".", desc = "Dot Files", action = file(dot_dir) },
          { icon = " ", key = "c", desc = "Config", action = file(config_dir) },
          { icon = " ", key = "z", desc = "Zettle Kastle", action = ":ZkNotes" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
    },
  },
}
