local logo = [[
     ██╗     ██╗███╗   ██╗ ██████╗ ███████╗██╗  ██╗██╗███╗   ██╗██╗     
     ██║     ██║████╗  ██║██╔════╝ ██╔════╝██║  ██║██║████╗  ██║██║    ⟡
     ██║ ⛧   ██║██╔██╗ ██║██║  ███╗███████╗███████║██║██╔██╗ ██║██║     
     ██║     ██║██║╚██╗██║██║   ██║╚════██║██╔══██║██║██║╚██╗██║╚═╝ ⟡   
 𓇼   ███████╗██║██║ ╚████║╚██████╔╝███████║██║  ██║██║██║ ╚████║██╗  ⟡  
     ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚═╝     
                                -------------聆噺讨厌写代码             
]]

return {
  -- cursorline
  {
    "mvllow/modes.nvim",
    config = function()
      require("modes").setup({
        colors = {
          copy = "#f5c359",
          delete = "#c75c6a",
          insert = "#c3e88d",
          visual = "#c099ff",
        },

        -- Set opacity for cursorline and number background
        line_opacity = 0.15,

        -- Enable cursor highlights
        set_cursor = true,

        -- Enable cursorline initially, and disable cursorline for inactive windows
        -- or ignored filetypes
        set_cursorline = true,

        -- Enable line number highlights to match cursorline
        set_number = true,

        -- Disable modes highlights in specified filetypes
        -- Please PR commonly ignored filetypes
        ignore_filetypes = { "NvimTree", "TelescopePrompt" },
      })
    end,
  },

  -- dap
  {
    "rcarriga/nvim-dap-ui",
    opts = {},
    config = function(_, opts)
      local dap = require("dap")
      local dapUI = require("dapui")

      dapUI.setup(opts)
      dap.listeners.before.event_initialized["dapui_config"] = function()
        require("toggleterm").toggle()
        vim.keymap.set("n", "<M-i>", function()
          dap.step_into()
        end)
        vim.keymap.set("n", "<M-o>", function()
          dap.step_over()
        end)
        vim.keymap.set("n", "<M-u>", function()
          dap.step_out()
        end)
        vim.keymap.set("n", "<M-p>", function()
          dap.terminate()
        end)
      end

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapUI.open({})
      end

      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapUI.close({})
        vim.keymap.del("n", "<M-i>")
        vim.keymap.del("n", "<M-o>")
        vim.keymap.del("n", "<M-u>")
        vim.keymap.del("n", "<M-p>")
      end

      dap.listeners.before.event_exited["dapui_config"] = function()
        dapUI.close({})
      end
    end,
  },

  -- snacks
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      animate = { enabled = false },
      bigfile = { enabled = true },
      indent = { enabled = true },
      styles = {
        input = { relative = "cursor", row = -3, col = 3 },
      },
      notifier = { enabled = true, timeout = 3000 },
      quickfile = { enabled = true },
      scroll = { enabled = true },
      explorer = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      dashboard = {
        enabled = true,
        preset = {
          -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
          ---@type fun(cmd:string, opts:table)|nil
          pick = nil,
          -- Used by the `keys` section to show keymaps.
          -- Set your custom keymaps here.
          -- When using a function, the `items` argument are the default keymaps.
          ---@type snacks.dashboard.Item[]
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            -- { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            {
              icon = " ",
              key = ".",
              desc = "Dot Files",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.env.XDG_CONFIG_HOME or '~/.config'})",
            },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
          -- Used by the `header` section
          header = logo,
        },
      },
    },
  },
}
