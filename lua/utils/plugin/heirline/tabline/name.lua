local M = {}
local resolver = require "utils.plugin.heirline.tabline.resolver"

local icons = { "󰲡", "󰲣", "󰲥", "󰲧", "󰲩", "󰲫", "󰲭", "󰲯", "󰲱", "󰿭" }

function M.get_icons(tabnr, is_active) return is_active and "󰻂" or icons[tabnr] or "󰆣" end

M.tabname = {}

local function formatname(name)
  if name and name ~= "" then return vim.fn.fnamemodify(name, ":t") end
  return "[Empty]"
end

function M.set()
  Snacks.input({
    prompt = "New Tab Name",
    win = {
      relative = "editor",
      col = false, ---@diagnostic disable-line:assign-type-mismatch
      row = 0.3,
    },
  }, function(input)
    if not input then return end
    M.tabname[vim.api.nvim_get_current_tabpage()] = input
  end)
end

function M.get(tabpage) return M.tabname[tabpage] or formatname(resolver.tabname(tabpage)) end

function M.save()
  local global = {}
  for k, v in pairs(M.tabname) do
    global[vim.api.nvim_tabpage_get_number(k)] = v
  end
  vim.g.LingshinTab = vim.json.encode(global)
end

function M.load()
  local global = vim.g.LingshinTab
  global = global and vim.json.decode(global, { luanil = { array = true } })
  if global then M.tabname = global end
end

return M
