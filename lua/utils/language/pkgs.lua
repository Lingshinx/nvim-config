---@param left any[]?
---@param right any[]?
---@param length integer
---@return integer
local function extend(left, right, length)
  if not right then return length end
  for _, value in ipairs(right) do
    left[length] = value
    length = length + 1
  end
  return length
end

local function get_names(lang)
  local pkgs, length = {}, 1
  local lsp = lang.lsp
  if type(lsp) == "string" then
    if not (lang.disable and vim.tbl_contains(lang.disable, lsp)) then
      length = length + 1
      pkgs[#pkgs + 1] = lsp
    end
  elseif type(lsp) == "table" then
    local lspnames = vim.iter(pairs(lsp)):map(function(k, v) return type(k) == "number" and v or k end)
    if lang.disable then
      lspnames = lspnames:filter(function(name) return not vim.tbl_contains(lang.disable, name) end)
    end
    length = extend(pkgs, lspnames:totable(), length)
  end
  local formatter = lang.formatter
  if formatter then extend(pkgs, formatter, length) end
  return vim
    .iter(pkgs)
    :map(function(pkg)
      local replaced = pkg:gsub("_", "-")
      return replaced
    end)
    :totable()
end

---@return string[]
local function get_pkgs()
  local langs = require "load.langs"
  local ret, length = {}, 1
  length = extend(ret, langs.package, length)
  length = extend(ret, langs[vim.g.config_installer], length)
  extend(ret, vim.iter(vim.tbl_values(langs.data)):map(get_names):flatten():totable(), length)
  ret = vim.list.unique(ret)
  return ret
end

return get_pkgs
