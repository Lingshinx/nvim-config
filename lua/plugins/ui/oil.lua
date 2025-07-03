return {
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      default_file_explorer = true,
      use_default_keymaps = false,
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      watch_for_changes = true,
      keymaps = {
        ["<CR>"] = "actions.select",
        ["<M-v>"] = { "actions.select", opts = { vertical = true } },
        ["<M-s>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-c>"] = { "actions.close", mode = "n" },
        ["K"] = { "actions.preview", mode = "n" },
        ["<BS>"] = { "actions.parent", mode = "n" },
        ["g?"] = { "actions.show_help", mode = "n" },
        ["gx"] = "actions.open_external",
        ["<leader>R"] = "actions.refresh",
        ["<leader>oh"] = { "actions.open_cwd", mode = "n" },
        ["<leader>os"] = { "actions.change_sort", mode = "n" },
        ["<leader>uh"] = { "actions.toggle_hidden", mode = "n" },
        ["<leader>or"] = { "actions.toggle_trash", mode = "n" },
      },
    },
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },

    lazy = false,

    keys = {
      { "<leader>fo", "<cmd>Oil<CR>", desc = "Oil" },
    },
  },

  {
    "JezerM/oil-lsp-diagnostics.nvim",
    dependencies = { "stevearc/oil.nvim" },
  },
}
