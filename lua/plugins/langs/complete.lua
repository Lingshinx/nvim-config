return {
  { "rafamadriz/friendly-snippets", load_before = "blink.cmp" },
  { "saghen/blink.lib", load_before = "blink.cmp" },
  {
    "saghen/blink.cmp",
    main = "blink-cmp",
    event = "InsertEnter",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "enter",
        ["<C-x><C-o>"] = { "show", "fallback" },
        ["<C-x><C-i>"] = { function(cmp) return cmp.show { providers = { "buffer" } } end },
      },

      cmdline = { enabled = false },
      appearance = {
        nerd_font_variant = "normal",
        kind_icons = require("config.icons").kinds,
      },

      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
            blocked_filetypes = { "kotlin" },
          },
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = {
          enabled = true,
        },
      },

      signature = { enabled = true },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = {
          lua = { inherit_defaults = true, "lazydev" },
        },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
      },
    },
  },
}
