return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    init = function(plugin)
      require("lazy.core.loader").add_to_rtp(plugin)
      require "nvim-treesitter.query_predicates"
    end,
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "<Up>", desc = "Increment Selection", mode = { "n", "x" } },
      { "<Down>", desc = "Decrement Selection", mode = "x" },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = { "LazyFile", "BufAdd" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      ---@type TSConfig
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup {
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<Up>",
            node_incremental = "<Up>",
            scope_incremental = false,
            node_decremental = "<Down>",
          },
        },
        ensure_installed = require("config.language").treesitter,
        textobjects = {
          lsp_interop = {
            enable = true,
            border = "none",
            floating_preview_opts = {},
            peek_definition_code = {
              ["<leader>K"] = "@function.outer",
            },
          },
          swap = {
            enable = true,
            swap_previous = {
              ["<aa"] = "@parameter.inner",
              ["<ia"] = "@parameter.inner",
              ["<af"] = "@function.outer",
              ["<if"] = "@function.inner",
              ["<ac"] = "@class.outer",
              ["<ic"] = "@class.outer",
            },
            swap_next = {
              [">aa"] = "@parameter.inner",
              [">ia"] = "@parameter.inner",
              [">af"] = "@function.outer",
              [">if"] = "@function.outer",
              [">ac"] = "@class.outer",
              [">ic"] = "@class.outer",
            },
          },
          select = {
            enable = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
            },
          },
          move = {
            enable = true,
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
              ["]a"] = "@parameter.inner",
            },
            goto_next_end = {
              ["]F"] = "@function.outer",
              ["]C"] = "@class.outer",
              ["]A"] = "@parameter.inner",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
              ["[a"] = "@parameter.inner",
            },
            goto_previous_end = {
              ["[F"] = "@function.outer",
              ["[C"] = "@class.outer",
              ["[A"] = "@parameter.inner",
            },
          },
        },
      }
    end,
  },
}
