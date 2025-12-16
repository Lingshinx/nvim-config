local function complete(source)
  return function() require("blink-cmp").show { providers = { source } } end
end

local spell_source = { "path", "snippets", "dictionary", "thesaurus" }
local no_spell_source = { "path", "snippets" }

local function text_source()
  return vim.o.spell and spell_source or no_spell_source
end
return {
  "saghen/blink.cmp",
  version = "1.*",
  -- build = "cargo build --release",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "archie-judd/blink-cmp-words",
    "L3MON4D3/LuaSnip",
    {
      "saghen/blink.compat",
      optional = true, -- make optional so it's only enabled if any extras need it
      opts = {},
      version = not vim.g.lazyvim_blink_main and "*",
    },
  },
  event = "InsertEnter",

  keys = {
    { "<M-f>", complete "path", mode = "i", desc = "Complete File" },
    { "<M-b>", complete "buffer", mode = "i", desc = "Complete Buffer" },
    { "<M-w>", complete "thesaurus", mode = "i", desc = "Complete Buffer" },
    { "<M-d>", complete "dictionary", mode = "i", desc = "Complete Buffer" },
  },

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    appearance = {
      -- sets the fallback highlight groups to nvim-cmp's highlight groups
      -- useful for when your theme doesn't support blink.cmp
      -- will be removed in a future release, assuming themes add support
      use_nvim_cmp_as_default = false,
      -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- adjusts spacing to ensure icons are aligned
      nerd_font_variant = "normal",
      kind_icons = require("config.icons").kinds,
    },
    completion = {
      accept = {
        -- experimental auto-brackets support
        auto_brackets = {
          enabled = true,
          -- blocked_filetypes = { "kotlin" },
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

    -- experimental signature help support
    signature = { enabled = true },

    snippets = { preset = "luasnip" },
    sources = {
      -- adding any nvim-cmp sources here will enable them
      -- with blink.compat
      -- compat = {},
      default = { "lsp", "path", "snippets", "buffer" },
      per_filetype = {
        lua = { inherit_defaults = true, "lazydev" },
        text = text_source,
        markdown = text_source,
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

        dictionary = {
          name = "blink-cmp-words",
          module = "blink-cmp-words.dictionary",
          opts = {
            dictionary_search_threshold = 2,
            score_offset = 0,
            definition_pointers = { "!", "&", "@", "^" },
          },
        },
      },
    },

    cmdline = {
      enabled = false,
    },

    keymap = {
      preset = "enter",
    },
  },
}
