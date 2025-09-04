return {
  {
    "stevearc/oil.nvim",
    lazy = vim.fn.argc(-1) == 0,
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
        ["<leader>od"] = {
          desc = "Oil toggle detail",
          callback = function()
            vim.b.detail = not vim.b.detail
            require("oil").set_columns(vim.b.detail and { "icon", "permissions", "size", "mtime" } or { "icon" })
          end,
        },
      },
      float = {
        max_height = 30,
        max_width = 80,
      },
    },
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },

    keys = {
      { "<leader>fo", function() require("oil").toggle_float() end, desc = "Oil" },
      { "<BS>", "<cmd>Oil<CR>", desc = "Oil" },
    },

    config = function(_, opts)
      require("oil").setup(opts)
      vim.api.nvim_create_autocmd("User", {
        pattern = "OilActionsPost",
        callback = function(event)
          if event.data.actions.type == "move" then
            Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
          end
        end,
      })
    end,
  },

  {
    "JezerM/oil-lsp-diagnostics.nvim",
    lazy = true,
    dependencies = { "stevearc/oil.nvim" },
  },
}
