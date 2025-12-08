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
    task_list = {
      direction = "right",
      keymaps = {
        ["<C-s>"] = false,
        ["<C-v>"] = false,
        ["<C-e>"] = false,
        ["o"] = false,
        ["g?"] = false,
        ["R"] = { "keymap.run_action", opts = { action = "watch" }, desc = "Auto task" },
        ["r"] = { "keymap.run_action", opts = { action = "restart" }, desc = "Restart task" },
        ["i"] = { "keymap.run_action", opts = { action = "edit" }, desc = "Edit task" },
        ["|"] = { "keymap.open", opts = { dir = "vsplit" }, desc = "Open task output in vsplit" },
        ["-"] = { "keymap.open", opts = { dir = "split" }, desc = "Open task output in split" },
      },
    },
  },
  config = function(_, opts)
    require("overseer").setup(opts)
    require "utils.plugin.overseer"
  end,
}
