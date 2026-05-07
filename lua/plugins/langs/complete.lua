return {
  { "rafamadriz/friendly-snippets" },
  { "saghen/blink.lib" },
  {
    "saghen/blink.cmp",
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
          thesaurus = {
            name = "blink-cmp-words",
            module = "blink-cmp-words.thesaurus",
            opts = {
              score_offset = 0,
              -- Default pointers define the lexical relations listed under each definition,
              -- see Pointer Symbols below.
              -- Default is as below ("antonyms", "similar to" and "also see").
              definition_pointers = { "!", "@", "^" },
              -- The pointers that are considered similar words when using the thesaurus,
              -- see Pointer Symbols below.
              -- Default is as below ("similar to", "also see" }
              similarity_pointers = { "&", "^" },
              -- The depth of similar words to recurse when collecting synonyms. 1 is similar words,
              -- 2 is similar words of similar words, etc. Increasing this may slow results.
              similarity_depth = 2,
            },
          },
        },
      },
    },
  },
  after = function(spec)
    require("lz.n").trigger_load "LuaSnip"
    require("blink-cmp").setup(spec.opts)
  end,
}
