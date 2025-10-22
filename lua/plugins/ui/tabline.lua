return {
  "nanozuki/tabby.nvim",
  event = "VeryLazy",
  keys = {
    { "<S-l>", "<cmd>tabn<cr>", desc = "Tab Next" },
    { "<S-h>", "<cmd>tabp<cr>", desc = "Tab Prev" },
    { "<leader><tab>H", "<cmd>-tabm<cr>", desc = "Next" },
    { "<leader><tab>L", "<cmd>+tabm<cr>", desc = "Previous" },
  },
  ---
  config = function()
    local get = require("utils.highlight.fn").getter
    local set = require("utils.highlight.fn").setter
    local current = set.Normal { bold = true, italic = true }
    local tabline = set.Comment { bg = "#151924" }
    local tabicon = get.Special
    local space = " "
    local theme = {
      icon = tabicon,
      fill = tabline,
      head = { fg = get.Tabline.bg, bg = get.Special.fg },
      current_tab = current,
      tab = tabline,
      current_win = current,
      win = tabline,
      tail = tabline,
    }
    local number = { "󰲡", "󰲣", "󰲥", "󰲧", "󰲩", "󰲫", "󰲭", "󰲯", "󰲱", "󰿭" }
    ---@module "tabby"
    ---@type TabbyConfig
    require("tabby").setup {
      option = {},
      line = function(line)
        local grapple = require "grapple"
        return {
          line.tabs().foreach(function(tab)
            local hl = tab.is_current() and theme.current_tab or theme.tab
            local jump_key = tab.jump_key()
            return {
              jump_key == "" and space or jump_key,
              tab.is_current() and { "󰻂", hl = theme.icon } or number[tab.number()] or "󰆣",
              tab.name(),
              space,
              hl = hl,
              margin = space,
            }
          end),
          line.spacer(),
          line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
            local icon, hl = Snacks.util.icon(win.buf_name())
            local opts = { buffer = win.buf().id }
            return {
              space,
              { icon, hl = hl },
              win.buf_name(),
              hl = win.is_current() and theme.current_win or theme.win,
              grapple.exists(opts) and {
                "󰛢",
                grapple.name_or_index(opts),
                space,
                hl = get["@comment.warning"],
              },
              margin = space,
            }
          end),
          { "  ", hl = theme.tail },
          hl = theme.fill,
        }
      end,
    }
  end,
}
