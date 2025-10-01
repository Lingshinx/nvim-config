return {
  {
    "mason-org/mason.nvim",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
        keymaps = {
          uninstall_package = "dd",
        },
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local lsp = require "config.lsp"
      local registry = require "mason-registry"
      local function install(pkg)
        if not registry.is_installed(pkg) and registry.has_package(pkg) then
          vim.notify("installing " .. pkg .. "..")
          registry.get_package(pkg):install()
        end
      end
      for _, pkg in ipairs(lsp.lsp) do
        install(pkg)
      end
      for _, formatters in pairs(lsp.formatter) do
        for _, formatter in ipairs(formatters) do
          install(formatter)
        end
      end
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    dependencies = {
      "mason.nvim",
    },
  },
}
