return {
  plugins = {
    {
      "mistweaverco/kulala.nvim",
      ft = "http",
      keys = {
        { "<leader>R", "", desc = "+Rest" },
        { "<leader>Rb", function() require("kulala").scratchpad() end, desc = "Open scratchpad" },
        { "<leader>Rc", function() require("kulala").copy() end, desc = "Copy as cURL", ft = "http" },
        { "<leader>RC", function() require("kulala").from_curl() end, desc = "Paste from curl", ft = "http" },
        { "<leader>Re", function() require("kulala").set_selected_env() end, desc = "Set environment", ft = "http" },
        { "<leader>Ri", function() require("kulala").inspect() end, desc = "Inspect current request", ft = "http" },
        { "<leader>Rn", function() require("kulala").jump_next() end, desc = "Jump to next request", ft = "http" },
        { "<leader>Rp", function() require("kulala").jump_prev() end, desc = "Jump to previous request", ft = "http" },
        { "<leader>Rq", function() require("kulala").close() end, desc = "Close window", ft = "http" },
        { "<leader>Rr", function() require("kulala").replay() end, desc = "Replay the last request" },
        { "<leader>Rs", function() require("kulala").run() end, desc = "Send the request", ft = "http" },
        { "<leader>RS", function() require("kulala").show_stats() end, desc = "Show stats", ft = "http" },
        { "<leader>Rt", function() require("kulala").toggle_view() end, desc = "Toggle headers/body", ft = "http" },
        {
          "<leader>Rg",
          function() require("kulala").download_graphql_schema() end,
          desc = "Download GraphQL schema",
          ft = "http",
        },
      },
      opts = {},
    },
  },
}
