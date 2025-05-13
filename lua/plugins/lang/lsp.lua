return {
  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
        "typst",
        "solyrc",
        "sognasm",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tinymist = {
          offset_encoding = "utf-8",
          single_file_support = true,
          settings = {
            exportPdf = "never",
          },
          root_dir = function()
            return vim.fn.getcwd()
          end,
        },
      },
      setup = {
        clangd = function(_, opts)
          opts.capabilities.offsetEncoding = { "utf-16" }
        end,
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        sqlfmt = {
          prepend_args = { "-l", "50" },
        },
      },
      formatters_by_ft = {
        sql = { "sqlfmt" },
        python = { "ruff" },
      },
    },
  },

  { "mason-org/mason.nvim", version = "1.11.0" },
  { "mason-org/mason-lspconfig.nvim", version = "1.32.0" },
}
