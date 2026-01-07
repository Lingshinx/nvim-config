local api = vim.api

local M = {}

function M.bufname(buf)
  local buftype = vim.bo[buf].buftype
  if buftype == "" or buftype == "terminal" then return api.nvim_buf_get_name(buf) end
  if buftype == "acwrite" and vim.bo[buf].filetype == "oil" then
    return require("oil").get_current_dir(buf):sub(1, -2)
  end
end

function M.winname(win) return M.bufname(api.nvim_win_get_buf(win)) end

function M.tabname(tab) return M.winname(api.nvim_tabpage_get_win(tab)) end

---@param buf integer
---@param fallback? string|{icon:string, hl:string}
---@return {icon:string, name:string, hl:string, [string]:any}
function M.buficon(buf, fallback)
  local buftype = vim.bo[buf].buftype
  local bufname = M.bufname(buf)
  local icon
  local hl
  if buftype == "" then
    icon, hl = Snacks.util.icon(api.nvim_buf_get_name(buf))
  elseif buftype == "terminal" then
    icon, hl = "", "String"
  elseif buftype == "acwrite" and vim.bo[buf].filetype == "oil" then
    icon, hl = "", "DiagnosticWarn"
  elseif type(fallback) == "table" then
    icon, hl = fallback.icon, fallback.hl
  elseif type(fallback) == "string" then
    icon = fallback
  else
    icon = ""
  end
  return {
    icon = icon,
    name = bufname,
    hl = hl,
  }
end

function M.winicon(win, fallback) return M.buficon(api.nvim_win_get_buf(win), fallback) end

function M.tabicon(tab, fallback) return M.winicon(api.nvim_tabpage_get_win(tab), fallback) end

function M.is_full_size() return vim.o.columns > 135 end

function M.norm_wins(tab)
  return vim
    .iter(api.nvim_tabpage_list_wins(tab))
    :filter(function(win) return api.nvim_get_option_value("buftype", { buf = api.nvim_win_get_buf(win) }) == "" end)
    :totable()
end

return M
