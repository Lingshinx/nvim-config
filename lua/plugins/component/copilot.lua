local username = require("config.utils.fn").capitalize(vim.env.USER or "USER")
return {
  "CopilotC-Nvim/CopilotChat.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim", branch = "master" },
  },
  build = "make tiktoken",
  opts = {
    auto_insert_mode = true,
    headers = {
      user = "  " .. username .. " ",
      assistant = "  Copilot ",
      tool = " Tool",
    },
    model = "gemini-2.5-pro",
    window = {
      width = 0.4,
    },
  },

  config = function(_, opts)
    local chat = require "CopilotChat"

    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "copilot-chat",
      callback = function()
        vim.opt_local.relativenumber = false
        vim.opt_local.number = false
      end,
    })

    chat.setup(opts)
  end,

  keys = {
    { "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
    { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
    {
      "<leader>aa",
      function() return require("CopilotChat").toggle() end,
      desc = "Toggle (CopilotChat)",
      mode = { "n", "v" },
    },
    {
      "<leader>ax",
      function() return require("CopilotChat").reset() end,
      desc = "Clear (CopilotChat)",
      mode = { "n", "v" },
    },
    {
      "<leader>aq",
      function()
        vim.ui.input({
          prompt = "Quick Chat: ",
        }, function(input)
          if input ~= "" then require("CopilotChat").ask(input) end
        end)
      end,
      desc = "Quick Chat (CopilotChat)",
      mode = { "n", "v" },
    },
    {
      "<leader>ap",
      function() require("CopilotChat").select_prompt() end,
      desc = "Prompt Actions (CopilotChat)",
      mode = { "n", "v" },
    },
  },
}
