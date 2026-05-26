if vim.g.config_installer ~= "mason" then return end

require("utils.manager").register {
  mason = {
    install = function(pkgs)
      if not package.loaded["mason"] then require("lz.n").trigger_load "mason.nvim" end
      if not pkgs or vim.tbl_isempty(pkgs) then pkgs = require "utils.language.pkgs"() end
      for _, pkg in ipairs(pkgs) do
        require("utils.plugin.mason").install(pkg)
      end
    end,
  },
}

return {
  "mason-org/mason.nvim",
  load_before = "nvim-lspconfig",
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
  after = function(spec) require("mason").setup(spec.opts) end,
}
