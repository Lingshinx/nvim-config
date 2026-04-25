local fn = require "utils.keymaps"
local pick, plug = fn.pick, fn.config
return {
  { "<leader>gd", pick "git_diff", desc = "Diff" },
  { "<leader>gs", pick "git_status", desc = "Status" },
  { "<leader>gS", pick "git_stash", desc = "Stash" },
  { "<leader>gg", plug "Lazygit", desc = "Lazygit" },
  { "<leader>gf", pick "git_log_file", desc = "File History" },
  { "<leader>gl", pick "git_log", desc = "Log" },
  { "<leader>gb", pick "git_log_line", desc = "Blame" },
}
