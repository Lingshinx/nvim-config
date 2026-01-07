return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
      {
        "<C-\\>",
        function()
          Snacks.terminal.toggle(nil, {
            win = {
              wo = {
                winhighlight = "NormalFloat:Normal,FloatBorder:Normal",
              },
              relative = "editor",
              position = "float",
              width = 0.8,
              max_width = 130,
              height = 0.85,
              min_height = 20,
              backdrop = 100,
            },
          })
        end,
        "ToggleTerm",
        mode = { "n", "t" },
      },
      {
        "K",
        function()
          if Snacks.image.supports_terminal() then
            Snacks.image.hover()
          else
            Snacks.image.doc.at_cursor(vim.ui.open)
          end
        end,
        "image hover",
        ft = "markdown",
      },
    },
    ---@module "snacks"
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      image = { enabled = true },
      zen = { enabled = true },
      input = { enabled = true },
      dim = { enabled = true },
      indent = { enabled = true },
      notifier = { enabled = true, timeout = 3000 },
      quickfile = { enabled = true },
      explorer = { enabled = true },
      words = { enabled = true },
      styles = {
        input = { relative = "cursor", row = -3, col = 3 },
        terminal = {
          border = "rounded",
        },
      },
    },
  },

  {
    "folke/flash.nvim",
    optional = true,
    specs = {
      {
        "folke/snacks.nvim",
        opts = {
          picker = {
            win = {
              input = {
                keys = {
                  ["<M-x>"] = { "flash", mode = { "n", "i" } },
                  ["X"] = { "flash" },
                },
              },
            },
            actions = {
              flash = function(picker)
                require("flash").jump {
                  pattern = "^",
                  label = { after = { 0, 0 } },
                  search = {
                    mode = "search",
                    exclude = {
                      function(win) return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list" end,
                    },
                  },
                  action = function(match)
                    local idx = picker.list:row2idx(match.pos[1])
                    picker.list:_move(idx, true, true)
                  end,
                }
              end,
            },
          },
        },
      },
    },
  },
}
