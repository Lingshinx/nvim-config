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
        ["|"] = { "actions.select", opts = { vertical = true } },
        ["-"] = { "actions.select", opts = { horizontal = true } },
        ["<Tab>"] = { "actions.select", opts = { tab = true } },
        ["<C-c>"] = { "actions.close", mode = "n" },
        ["K"] = { "actions.preview", mode = "n" },
        ["<BS>"] = { "actions.parent", mode = "n" },
        ["g?"] = { "actions.show_help", mode = "n" },
        ["gx"] = "actions.open_external",
        ["<C-y>"] = "actions.copy_to_system_clipboard",
        ["<C-p>"] = "actions.paste_from_system_clipboard",
        ["<leader>R"] = "actions.refresh",
        ["<leader>oh"] = { "actions.open_cwd", mode = "n" },
        ["<leader>os"] = { "actions.change_sort", desc = "Oil change sort", mode = "n" },
        ["<leader>uh"] = { "actions.toggle_hidden", desc = "Oil toggle hidden", mode = "n" },
        ["<leader>or"] = { "actions.toggle_trash", desc = "Oil trash", mode = "n" },
        ["<leader>sr"] = {
          desc = "Search / Replace",
          callback = function()
            local prefills = { paths = require("oil").get_current_dir() }
            local grug_far = require "grug-far"
            if not grug_far.has_instance "explorer" then
              grug_far.open {
                instanceName = "explorer",
                prefills = prefills,
                staticTitle = "Find and Replace from Explorer",
              }
            else
              grug_far.get_instance("explorer"):open()
              grug_far.get_instance("explorer"):update_input_values(prefills, false)
            end
          end,
        },
        ["<leader>od"] = {
          desc = "Oil toggle detail",
          callback = function()
            vim.b.detail = not vim.b.detail
            require("oil").set_columns(vim.b.detail and { "icon", "permissions", "size", "mtime" } or { "icon" })
          end,
        },
        ["<c-\\>"] = {
          desc = "Terminal",
          callback = function()
            Snacks.terminal.toggle(nil, {
              cwd = require("oil").get_current_dir(0),
              win = {
                style = "minimal",
                position = "right",
                wo = {
                  winhighlight = "NormalFloat:Normal,FloatBorder:Normal",
                },
              },
            })
          end,
        },
        ["<leader>fz"] = {
          desc = "Zoxide",
          callback = function()
            Snacks.picker.zoxide {
              actions = {
                confirm = function(picker, item)
                  picker:close()
                  require("oil").open(item.file)
                end,
              },
            }
          end,
        },
      },
      float = {
        max_height = 30,
        max_width = 80,
      },
    },
    -- Optional dependencies
    dependencies = { { "nvim-mini/mini.icons", config = function() end } },

    keys = {
      { "<leader>fo", function() require("oil").toggle_float() end, desc = "Oil" },
      {
        "<BS>",
        function()
          if #require("utils.winbuf").norm_wins(0) == 1 and require("utils.winbuf").is_full_size() then
            require("oil").open(nil, { preview = { vertical = true } })
          else
            require("oil").open()
          end
        end,
        desc = "Oil",
      },
    },

    cmd = { "Oil" },

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
