local resolver = require "utils.plugin.heirline.tabline.resolver"

local function not_float_win(winid) return vim.api.nvim_win_get_config(winid).relative == "" end

local function regular_wins(tab)
  return vim
    .iter(vim.api.nvim_tabpage_list_wins(tab))
    :filter(not_float_win)
    :map(function(winid)
      local iconname = resolver.winicon(winid)
      iconname.id = winid
      return iconname
    end)
    :filter(function(win) return win.name and win.name ~= "" end)
    :totable()
end
local function add_index(str)
  local ret = {}
  local count = 1
  for char in str:gmatch "." do
    ret[char] = count
    count = count + 1
  end
  return ret
end

local labels = "asdfjklghvbnyuio"
local labelToNum = add_index "asdfjklghvbnyuio"

return {
  Cut = { provider = "%<" },
  Align = { provider = " %= " },

  labels = labels,
  labelToNum = labelToNum,

  regular_wins = regular_wins,

  pick = function()
    local tabline = require("heirline").tabline
    ---@diagnostic disable-next-line
    tabline._show_picker = true

    vim.cmd.redrawtabline()
    local char = vim.fn.getcharstr()
    local tab = labelToNum[char]
    local tabs = vim.api.nvim_list_tabpages()
    ---@diagnostic disable-next-line
    tabline._show_picker = false
    if tab and tabs[tab] then
      vim.api.nvim_set_current_tabpage(tabs[tab])
    else
      vim.api.nvim_feedkeys(char, "n", false)
    end

    vim.api.nvim_exec_autocmds("WinLeave", {})
    vim.cmd.redrawtabline()
  end,

  eventsToUpdateTabline = {
    "TabEnter",
    "TabNew",
    "TabClosed",
    "WinNew",
    "WinClosed",
    "WinLeave",
    "WinEnter",
    "BufWinEnter",
    "BufWinLeave",
    "BufDelete",
  },

  make_winlist = function(tab_component)
    return {
      init = function(self)
        local wins = regular_wins(0)
        local cur_win = vim.api.nvim_get_current_win()
        for i, win in ipairs(wins) do
          local child = self[i]

          if not (child and child.winnr == win) then
            self[i] = self:new(tab_component, i)
            child = self[i]
            child.winnr = win.id
            child.icon_hl = win.hl
            child.icon = win.icon
            child.winname = win.name
          end
          child.is_active = win.id == cur_win
        end
        if #self > #wins then
          for i = #self, #wins + 1, -1 do
            self[i] = nil
          end
        end
      end,
    }
  end,
}
