return {
  lsp = "copilot-language-server",
  treesitter = false,
  plugins = {
    {
      "folke/snacks.nvim",
      optional = true,
      opts = {
        picker = {
          actions = {
            sidekick_send = function(...) return require("sidekick.cli.picker.snacks").send(...) end,
          },
          win = {
            input = {
              keys = {
                ["<a-a>"] = {
                  "sidekick_send",
                  mode = { "n", "i" },
                },
              },
            },
          },
        },
      },
    },
    -- {
    --   "saghen/blink.cmp",
    --   optional = true,
    --   ---@module 'blink.cmp'
    --   ---@type blink.cmp.Config
    --   opts = {
    --     keymap = {
    --       ["<Tab>"] = {
    --         "snippet_forward",
    --         function() -- sidekick next edit suggestion
    --           return require("sidekick").nes_jump_or_apply()
    --         end,
    --         function() -- if you are using Neovim's native inline completions
    --           return vim.lsp.inline_completion.get()
    --         end,
    --         "fallback",
    --       },
    --     },
    --   },
    -- },
    {
      "folke/sidekick.nvim",
      opts = {},
      keys = {
        {
          "<leader>aa",
          function() require("sidekick.cli").toggle() end,
          desc = "Sidekick Toggle CLI",
        },
        {
          "<leader>as",
          function() require("sidekick.cli").select() end,
          -- Or to select only installed tools:
          -- require("sidekick.cli").select({ filter = { installed = true } })
          desc = "Select CLI",
        },
        {
          "<leader>ad",
          function() require("sidekick.cli").close() end,
          desc = "Detach a CLI Session",
        },
        {
          "<leader>at",
          function() require("sidekick.cli").send { msg = "{this}" } end,
          mode = { "x", "n" },
          desc = "Send This",
        },
        {
          "<leader>af",
          function() require("sidekick.cli").send { msg = "{file}" } end,
          desc = "Send File",
        },
        {
          "<leader>av",
          function() require("sidekick.cli").send { msg = "{selection}" } end,
          mode = { "x" },
          desc = "Send Visual Selection",
        },
        {
          "<leader>ap",
          function() require("sidekick.cli").prompt() end,
          mode = { "n", "x" },
          desc = "Select Prompt",
        },
        -- Example of a keybinding to open Claude directly
        {
          "<leader>ac",
          function() require("sidekick.cli").toggle { name = "claude", focus = true } end,
          desc = "Toggle Claude",
        },
      },
    },
  },
}
