return {
  "stevearc/overseer.nvim",
  cmd = {
    "OverseerOpen",
    "OverseerClose",
    "OverseerToggle",
    "OverseerSaveBundle",
    "OverseerLoadBundle",
    "OverseerDeleteBundle",
    "OverseerRunCmd",
    "OverseerRun",
    "OverseerInfo",
    "OverseerBuild",
    "OverseerQuickAction",
    "OverseerTaskAction",
    "OverseerClearCache",
  },
  keys = {
    { "<leader>ow", "<cmd>OverseerToggle<cr>", desc = "list" },
    { "<leader>oo", "<cmd>OverseerRun<cr>", desc = "Run" },
    { "<leader>oq", "<cmd>OverseerQuickAction<cr>", desc = "Quick action" },
    { "<leader>oi", "<cmd>OverseerInfo<cr>", desc = "Info" },
    { "<leader>ob", "<cmd>OverseerBuild<cr>", desc = "Builder" },
    { "<leader>ot", "<cmd>OverseerTaskAction<cr>", desc = "Task action" },
    { "<leader>oc", "<cmd>OverseerClearCache<cr>", desc = "Clear cache" },
  },
  config = function()
    local overseer = require "overseer"
    overseer.setup {
      dap = false,
      templates = { "make", "cargo", "shell" },
      task_list = {
        direction = "right",
        bindings = {
          ["<C-u>"] = false,
          ["<C-d>"] = false,
          ["<C-h>"] = false,
          ["<C-j>"] = false,
          ["<C-k>"] = false,
          ["<C-l>"] = false,
        },
      },
    }
    -- custom behavior of make templates
    overseer.add_template_hook({
      module = "^make$",
    }, function(task_defn, util)
      util.add_component(task_defn, { "on_output_quickfix", open_on_exit = "failure", close = true })
      util.add_component(task_defn, "on_complete_notify")
      util.add_component(task_defn, { "display_duration", detail_level = 1 })
    end)
  end,
}
