return {
  -- task manager
  {
    "stevearc/overseer.nvim",
    config = function()
      local overseer = require("overseer")
      overseer.setup({
        dap = false,
        templates = { "make", "cargo", "shell" },
        task_list = {
          direction = "right",
          bindings = {
            ["<C-u>"] = false,
            ["<C-d>"] = false,
            ["<C-h>"] = false,
            ["<C-j>"] = false,
            ["<C-k>"] = false,
            ["<C-l>"] = false,
          },
        },
      })
      -- custom behavior of make templates
      overseer.add_template_hook({
        module = "^make$",
      }, function(task_defn, util)
        util.add_component(task_defn, { "on_output_quickfix", open_on_exit = "failure", close = true })
        util.add_component(task_defn, "on_complete_notify")
        util.add_component(task_defn, { "display_duration", detail_level = 1 })
      end)
    end,
  },

  -- terminal
  {
    "akinsho/toggleterm.nvim",
    opts = {
      open_mapping = [[<C-\>]],
      hide_numbers = true,
      shell = "zsh",
      start_in_insert = true,
      direction = "float",
      float_opts = {
        border = "rounded",
        width = 130,
        title_pos = "center",
      },
      winbar = {
        enable = true,
        name_formatter = function(term)
          return term.name
        end,
      },
    },
  },

  {
    "max397574/colortils.nvim",
    cmd = "Colortils",
    opts = {},
  },

  -- HTTP client
  -- {
  --   "rest-nvim/rest.nvim",
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --     opts = function(_, opts)
  --       opts.ensure_installed = opts.ensure_installed or {}
  --       table.insert(opts.ensure_installed, "http")
  --     end,
  --   },
  -- },
}
