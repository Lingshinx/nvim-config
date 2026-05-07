local config = vim.fn.stdpath "config"
local dotfile = vim.env.XDG_CONFIG_HOME or "~/.config"

local fn = require "utils.keymaps"
local pick, file, cmd, plug = fn.pick, fn.file, fn.cmd, fn.config

return {
  { "<leader>fn", cmd "enew", desc = "New File" },
  { "<leader>fb", pick "buffers", desc = "Buffers" },
  { "<leader>ff", pick "files", desc = "Files" },
  { "<leader>fc", file(config), desc = "Config" },
  { "<leader>f.", file(dotfile), desc = "Dotfile" },
  { "<leader>fg", pick "git_files", desc = "Git" },
  { "<leader>fr", pick "recent", desc = "Recent" },
  { "<leader>fp", pick "projects", desc = "Projects" },
  { "<leader>fz", pick "zoxide", desc = "Zoxide" },
  { "<leader><space>", pick "smart", desc = "Files" },
  { "<leader>fs", plug "SratchOpen", desc = "Toggle Scratch Buffer" },
  { "<leader>fS", plug "SratchSelect", desc = "Select Scratch Buffer" },
}
