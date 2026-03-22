return {
  plugins = {
    {
      "Saecki/crates.nvim",
      event = { "BufRead Cargo.toml" },
      opts = {
        completion = {
          crates = {
            enabled = true,
          },
        },
        lsp = {
          enabled = true,
          actions = true,
          completion = true,
          hover = true,
        },
      },
    },
    {
      "mrcjkb/rustaceanvim",
      ft = { "rust" },
      config = function()
        vim.g.rustaceanvim = {
          server = {
            on_attach = function(_, bufnr)
              vim.keymap.set(
                "n",
                "<leader>cR",
                function() vim.cmd.RustLsp "codeAction" end,
                { desc = "Code Action", buffer = bufnr }
              )
              vim.keymap.set(
                "n",
                "<leader>dr",
                function() vim.cmd.RustLsp "debuggables" end,
                { desc = "Rust Debuggables", buffer = bufnr }
              )
            end,
            default_settings = {
              -- rust-analyzer language server configuration
              ["rust-analyzer"] = {
                cargo = {
                  allFeatures = true,
                  loadOutDirsFromCheck = true,
                  buildScripts = {
                    enable = true,
                  },
                },
                -- Add clippy lints for Rust if using rust-analyzer
                checkOnSave = true,
                -- Enable diagnostics if using rust-analyzer
                diagnostics = {
                  enable = true,
                },
                procMacro = {
                  enable = true,
                  ignored = {
                    ["async-trait"] = { "async_trait" },
                    ["napi-derive"] = { "napi" },
                    ["async-recursion"] = { "async_recursion" },
                  },
                },
                files = {
                  excludeDirs = {
                    ".direnv",
                    ".git",
                    ".github",
                    ".gitlab",
                    "bin",
                    "node_modules",
                    "target",
                    "venv",
                    ".venv",
                  },
                },
              },
            },
          },
        }
      end,
    },
  },
}
