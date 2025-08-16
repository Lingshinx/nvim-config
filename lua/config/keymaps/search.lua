local function picker(name)
	return require("config.utils.plugin.snacks")[name] or Snacks.picker[name]
end

-- stylua: ignore start
require("which-key").add({
  { "<leader>s/", picker("search_history"), desc = "Search History" },
  { "<leader>s:", picker("command_history"), desc = "Command History" },

	{ '<leader>s"', picker("registers"), desc = "Registers" },
	{ "<leader>sj", picker("jumps"), desc = "Jumps" },
  { "<leader>sm", picker("marks"), desc = "Marks" },

	{ "<leader>sa", picker("autocmds"), desc = "Autocmds" },
  { "<leader>sk", picker("keymaps"), desc = "Keymaps" },
  { "<leader>sc", picker("commands"), desc = "Commands" },

	{ "<leader>sb", picker("lines"), desc = "Buffer Lines" },
	{ "<leader>sB", picker("grep_buffers"), desc = "Buffers Grep " },
	{ "<leader>sw", picker("grep_word"), desc = "Word Grep", mode = { "n", "x" } },
	{ "<leader>sg", picker("grep"), desc = "Grep" },

	{ "<leader>sq", picker("qflist"), desc = "Quickfix" },
	{ "<leader>sl", picker("loclist"), desc = "Quickfix (Local)" },
	{ "<leader>sd", picker("diagnostics"), desc = "Diagnostics" },
	{ "<leader>sD", picker("diagnostics_buffer"), desc = "Diagnostics (Buffer)" },

	{ "<leader>sh", picker("help"), desc = "Help Pages" },
	{ "<leader>sM", picker("man"), desc = "Man Pages" },

	{ "<leader>sp", picker("lazy"), desc = "Plugins" },
	{ "<leader>sH", picker("highlights"), desc = "Highlights" },
	{ "<leader>su", picker("undo"), desc = "Undotree" },

	{ "<leader>sn", picker("notifications"), desc = "Notifications" },
  { "<leader>sf", picker("filetypes"), desc = "Filetypes" },
})
