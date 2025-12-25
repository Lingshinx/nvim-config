return {
  "nanozuki/tabby.nvim",
  event = "VeryLazy",
  keys = {
  },
  config = function()
    local get = require("utils.highlight.fn").getter
    local set = require("utils.highlight.fn").setter
    local current = set.Normal { bold = true, italic = true }
    local tabline = set.Comment { bg = "#151924" }
    local stress = get["@comment.warning"]
    local tabicon = get.Special
    local space = " "
    local theme = {
      icon = tabicon,
      fill = tabline,
      stress = stress,
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
            local icon = tab.in_jump_mode() and { tab.jump_key(), hl = tab.is_current() and theme.icon or theme.stress }
              or tab.is_current() and { "󰻂", hl = theme.icon }
              or number[tab.number()]
              or "󰆣"
            return {
              space,
              icon,
              space,
              tab.name(),
              space,
              hl = hl,
            }
          end),
          line.spacer(),
          line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
            local buf = win.buf()
            local name = buf.name()
            local icon, hl = Snacks.util.icon(name)
            local opts = { buffer = win.buf().id }
            return {
              space,
              { icon, hl = hl },
              space,
              name,
              grapple.exists(opts) and {
                space,
                "󰛢",
                grapple.name_or_index(opts),
                space,
                hl = theme.stress,
              },
              space,
              hl = win.is_current() and theme.current_win or theme.win,
            }
          end),
          { "  ", hl = theme.tail },
          hl = theme.fill,
        }
      end,
    }
  end,
}
