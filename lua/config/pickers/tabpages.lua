local tabname = require "utils.plugin.heirline.tabline.name"
local winnames = require "utils.plugin.heirline.utils"
local active_tab = vim.api.nvim_get_current_tabpage()

---@type snacks.picker.Config|fun(snacks.picker.Config):snacks.picker.Config>
return {
  title = "Tabpages",
  layout = "vscode",
  sort_lastused = true,
  sort = { fields = { "tabnr" } },
  matcher = {
    sort_empty = true,
  },
  ---@param picker snacks.Picker
  format = function(item, picker)
    local align = Snacks.picker.util.align
    local width = vim.api.nvim_win_get_width(picker.layout.wins.list.win) - 2
    local tabicon = tabname.get_icons(item.tabpage, item.is_active)
    local left = 20
    local right = width - left

    local wins = vim
      .iter(item.wins)
      :map(function(win)
        local winname = vim.fn.fnamemodify(win.name, ":t")
        local winname_width = vim.api.nvim_strwidth(winname) + 4

        if winname_width > right then
          return nil
        else
          right = right - winname_width
        end

        return {
          { "  " },
          { align(win.icon, 2), win.hl },
          { winname },
        }
      end)
      :flatten(1)
      :totable()

    return {
      { align(tabicon, 2), item.is_active and "LingshinPickerFtFormatter" or "Special" },
      {
        align(item.name, left - 2, { truncate = true }),
        not item.is_active and "SnacksPickerDimmed",
      },
      { align(nil, right) },
      unpack(wins),
    }
  end,
  finder = function()
    return vim
      .iter(vim.api.nvim_list_tabpages())
      :map(function(tab)
        local name = tabname.get(tab)
        local wins = winnames.regular_wins(tab)
        local tabnr = vim.api.nvim_tabpage_get_number(tab)
        return {
          wins = wins,
          text = name .. table.concat(vim.tbl_map(function(win) return win.name end, wins)),
          tabpage = tab,
          name = name,
          tabnr = tabnr,
          is_active = tab == active_tab,
        }
      end)
      :totable()
  end,
  confirm = function(picker, item)
    picker:close()
    vim.api.nvim_set_current_tabpage(item.tabpage)
  end,
}
