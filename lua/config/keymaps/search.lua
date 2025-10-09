local picker = require("utils.plugin.snacks").picker

require("which-key").add {
  { "<leader>S", picker "pickers", desc = "All Searcher" },

  { "<leader>s/", picker "search_history", desc = "Search History" },
  { "<leader>s:", picker "command_history", desc = "Command History" },

  { '<leader>s"', picker "registers", desc = "Registers" },
  { "<leader>sj", picker "jumps", desc = "Jumps" },
  { "<leader>sm", picker "marks", desc = "Marks" },

  { "<leader>sa", picker "autocmds", desc = "Autocmds" },
  { "<leader>sk", picker "keymaps", desc = "Keymaps" },
  { "<leader>sc", picker "commands", desc = "Commands" },

  { "<leader>sb", picker "lines", desc = "Buffer Lines" },
  { "<leader>sB", picker "grep_buffers", desc = "Buffers Grep " },
  { "<leader>sw", picker "grep_word", desc = "Word Grep", mode = { "n", "x" } },
  { "<leader>sg", picker "grep", desc = "Grep" },

  { "<leader>sq", picker "qflist", desc = "Quickfix" },
  { "<leader>sl", picker "loclist", desc = "Quickfix (Local)" },
  { "<leader>sd", picker "diagnostics", desc = "Diagnostics" },
  { "<leader>sD", picker "diagnostics_buffer", desc = "Diagnostics (Buffer)" },

  { "<leader>sh", picker "help", desc = "Help Pages" },

  { "<leader>sp", picker "lazy", desc = "Plugins" },
  { "<leader>su", picker "undo", desc = "Undotree" },

  { "<leader>sn", picker "notifications", desc = "Notifications" },
  { "<leader>sf", picker "filetypes", desc = "Filetypes" },
  { "<leader>si", picker "icons", desc = "Icons" },
}
