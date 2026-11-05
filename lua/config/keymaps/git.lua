local fn = require "utils.keymaps"
local cmd, pick, plug = fn.cmd, fn.pick, fn.config
return {
  { "<leader>gd", cmd "DiffviewToggle", desc = "Diff" },
  { "<leader>gs", pick "git_status", desc = "Status" },
  { "<leader>gS", pick "git_stash", desc = "Stash" },
  { "<leader>gg", plug "Git", desc = "Git" },
  { "<leader>gf", cmd "DiffviewFileHistory", desc = "File History" },
  { "<leader>gl", pick "git_log", desc = "Log" },
  { "<leader>gb", pick "git_log_line", desc = "Blame" },
}
