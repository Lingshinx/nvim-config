local cmd = require("utils.keymaps").cmd

return {
  "stevearc/overseer.nvim",
  lazy = true,
  cmd = {
    "Make",
    "Grep",
    "OverseerClose",
    "OverseerOpen",
    "OverseerRun",
    "OverseerShell",
    "OverseerTaskAction",
    "OverseerToggle",
    "OverseerRestartLast",
  },
  keys = {
    { "<leader>ow", cmd "OverseerToggle", desc = "list" },
    { "<leader>or", cmd "OverseerRun", desc = "Run" },
    { "<leader>oo", cmd "OverseerRestartLast", desc = "Resume" },
    { "<leader>os", cmd "OverseerShell", desc = "Shell" },
    { "<leader>ot", cmd "OverseerTaskAction", desc = "Task action" },
  },
  opts = {
    dap = false,
    actions = {
      trouble = {
        desc = "open trouble on detecting error messages",
        condition = function(task) return not task:has_component "lingshin.on_output_trouble" end,
        run = function(task)
          task:set_component { "lingshin.on_output_trouble", open_on_match = true, errorformat = vim.o.errorformat }
        end,
      },
      watch = {
        desc = "restart the task when you save a file",
        condition = function(task) return not task:has_component "restart_on_save" end,
        run = function(task) task:set_component "restart_on_save" end,
      },
    },
    task_list = {
      direction = "right",
      keymaps = {
        ["<C-s>"] = false,
        ["<C-j>"] = false,
        ["<C-k>"] = false,
        ["<C-t>"] = false,
        ["<C-v>"] = false,
        ["<C-e>"] = false,
        ["p"] = false,
        ["o"] = false,
        ["g?"] = false,
        ["R"] = { "keymap.run_action", opts = { action = "watch" }, desc = "Auto task" },
        ["r"] = { "keymap.run_action", opts = { action = "restart" }, desc = "Restart task" },
        ["i"] = { "keymap.run_action", opts = { action = "edit" }, desc = "Edit task" },
        ["<C-q>"] = { "keymap.run_action", opts = { action = "trouble" }, desc = "Quickfix" },
        ["|"] = { "keymap.open", opts = { dir = "vsplit" }, desc = "Open task output in vsplit" },
        ["-"] = { "keymap.open", opts = { dir = "split" }, desc = "Open task output in split" },
        ["<Tab>"] = { "keymap.open", opts = { dir = "tab" }, desc = "Open task output in tab" },
        ["K"] = { "keymap.toggle_preview", desc = "Preview" },
      },
    },
  },
  after = function(spec)
    require("overseer").setup(spec.opts)
    require "utils.plugin.overseer"
  end,
}
