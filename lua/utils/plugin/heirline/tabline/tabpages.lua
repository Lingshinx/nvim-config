local utils = require "heirline.utils"
local name = require "utils.plugin.heirline.tabline.name"
local events = require("utils.plugin.heirline.utils").eventsToUpdateTabline
local labels = require("utils.plugin.heirline.utils").labels

local function get_picker(tabpage) return labels:sub(tabpage, tabpage):upper() end
local function not_empty_or(str, other) return str ~= "" and str or other end

local TabIcon = {
  fallthrough = false,
  {
    condition = function(self) return self._show_picker == true end,
    provider = function(self) return " " .. not_empty_or(get_picker(self.tabpage), "󰆣") end,
    hl = function(self) return { fg = self.is_active and "orange" or "cyan" } end,
  },
  {
    static = { icons = { "󰲡", "󰲣", "󰲥", "󰲧", "󰲩", "󰲫", "󰲭", "󰲯", "󰲱", "󰿭" } },
    provider = function(self) return " " .. (self.is_active and "󰻂" or self.icons[self.tabpage] or "󰆣") end,
    hl = function(self) return self.is_active and { fg = "cyan" } end,
  },
}

local TabName = {
  TabIcon,
  { provider = function(self) return " " .. name.get(self.tabpage) .. " " end },
  hl = function(self) return self.is_active and "Normal" or { fg = "gray" } end,
}

return utils.make_tablist {
  { provider = function(self) return "%" .. self.tabnr .. "T" end },
  TabName,
  { provider = "%T" },
  condition = function() return #vim.api.nvim_list_tabpages() >= 2 end,
  update = events,
}
