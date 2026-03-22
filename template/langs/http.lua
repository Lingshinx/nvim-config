return {
  plugins = {
    {
      "mistweaverco/kulala.nvim",
      ft = "http",
      keys = {
        { "<leader>rc", function() require("kulala").copy() end, desc = "Copy as cURL", ft = "http" },
        { "<leader>rC", function() require("kulala").from_curl() end, desc = "Paste from curl", ft = "http" },
        { "<leader>re", function() require("kulala").set_selected_env() end, desc = "Set environment", ft = "http" },
        { "]r", function() require("kulala").jump_next() end, desc = "Next request", ft = "http" },
        { "[r", function() require("kulala").jump_prev() end, desc = "Prev request", ft = "http" },
        { "<leader>rq", function() require("kulala").close() end, desc = "Close", ft = "http" },
        { "<leader>rr", function() require("kulala").replay() end, desc = "Recent request" },
        { "<leader>rs", function() require("kulala").run() end, desc = "Request", ft = "http" },
        { "<leader>rt", function() require("kulala").toggle_view() end, desc = "Toggle headers/body", ft = "http" },
        { "<leader>rv", function() require("kulala.ui").show_verbose() end, desc = "Verbose", ft = "http" },
        { "<leader>ra", function() require("kulala.ui").show_headers_body() end, desc = "Body", ft = "http" },
        { "<leader>rb", function() require("kulala.ui").show_body() end, desc = "scratchpad" },
        { "<leader>rg", function() require("kulala").download_graphql_schema() end, desc = "GraphQL", ft = "http" },
      },
      opts = {
        ui = {
          winbar = false,
          icons = {
            inlay = {
              loading = "󰄰",
              done = "󰄴",
              error = "",
            },
            textHighlight = "WarningMsg",
            show_request_summary = true,
            show_variable_info_text = "float",
          },
        },
        kulala_keymaps = false,
      },
    },
  },
}
