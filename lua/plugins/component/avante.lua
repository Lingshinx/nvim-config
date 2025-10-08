return {
  "yetone/avante.nvim",
  enabled = false,
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  -- ⚠️ must add this setting! ! !
  keys = {
    { "<leader>a", desc = "+ai", mode = { "n", "v" } },
  },
  build = "make",
  cmd = { "AvanteAsk", "AvanteChat", "AvanteChatNew", "AvanteHistory", "AvanteModels" },
  version = false, -- Never set this value to "*"! Never!
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    -- add any opts here
    -- this file can contain specific instructions for your project
    instructions_file = "avante.md",
    -- for example
    input = {
      provider = "snacks",
      provider_opts = {
        title = "Avante Input",
        icon = "",
      },
    },
    provider = "copilot",
    providers = {
      copilot = {
        model = "claude-sonnet-4",
      },
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-sonnet-4-20250514",
        timeout = 30000, -- Timeout in milliseconds
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 20480,
        },
      },
      moonshot = {
        endpoint = "https://api.moonshot.ai/v1",
        model = "kimi-k2-0711-preview",
        timeout = 30000, -- Timeout in milliseconds
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 32768,
        },
      },
    },
    behaviour = {
      auto_suggestions = true,
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "folke/snacks.nvim", -- for input provider snacks
    "zbirenbaum/copilot.lua", -- for providers='copilot'
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
