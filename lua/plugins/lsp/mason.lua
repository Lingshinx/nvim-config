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
      local lsp = require "config.language"
      local install = require("utils.plugin.mason").install
      for _, pkg in ipairs(lsp.mason) do
        install(pkg)
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
