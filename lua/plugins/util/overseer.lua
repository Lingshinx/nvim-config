return {
  "stevearc/overseer.nvim",
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
    { "<leader>ow", "<cmd>OverseerToggle<cr>", desc = "list" },
    { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run" },
    { "<leader>oo", "<cmd>OverseerRestartLast<cr>", desc = "Resume" },
    { "<leader>os", "<cmd>OverseerShell<cr>", desc = "Shell" },
    { "<leader>ot", "<cmd>OverseerTaskAction<cr>", desc = "Task action" },
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
  config = function(_, opts)
    require("overseer").setup(opts)
    require "utils.plugin.overseer"
  end,
}
