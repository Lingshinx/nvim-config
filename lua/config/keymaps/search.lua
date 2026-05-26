local pick = require("utils.keymaps").pick

return {
  { "<leader>S", pick "pickers", desc = "All Searcher" },

  { "<leader>s/", pick "search_history", desc = "Search History" },
  { "<leader>s:", pick "command_history", desc = "Command History" },

  { '<leader>s"', pick "registers", desc = "Registers" },
  { "<leader>sj", pick "jumps", desc = "Jumps" },
  { "<leader>sm", pick "marks", desc = "Marks" },

  { "<leader>sa", pick "autocmds", desc = "Autocmds" },
  { "<leader>sk", pick "keymaps", desc = "Keymaps" },
  { "<leader>sc", pick "commands", desc = "Commands" },

  { "<leader>sb", pick "lines", desc = "Buffer Lines" },
  { "<leader>sB", pick "grep_buffers", desc = "Buffers Grep " },
  { "<leader>sw", pick "grep_word", desc = "Word Grep", mode = { "n", "x" } },
  { "<leader>sg", pick "grep", desc = "Grep" },

  { "<leader>sq", pick "qflist", desc = "Quickfix" },
  { "<leader>sl", pick "loclist", desc = "Quickfix (Local)" },
  { "<leader>sd", pick "diagnostics", desc = "Diagnostics" },
  { "<leader>sD", pick "diagnostics_buffer", desc = "Diagnostics (Buffer)" },

  { "<leader>sh", pick "help", desc = "Help Pages" },

  { "<leader>sp", pick "lazy", desc = "Plugins" },
  { "<leader>su", pick "undo", desc = "Undotree" },

  { "<leader>sn", pick "notifications", desc = "Notifications" },
  { "<leader>sf", pick "filetypes", desc = "Filetypes" },
  { "<leader>si", pick "icons", desc = "Icons" },
}
