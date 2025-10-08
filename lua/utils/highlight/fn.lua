local M = {}

function M.get_by_name(name) return vim.api.nvim_get_hl(0, { name = name, link = false }) end

M.setter = setmetatable({}, {
  __index = function(_, index)
    return function(value) return vim.tbl_extend("force", M.get_by_name(index), value) end
  end,
})

---@class Config.highlight.Hl: vim.api.keyset.highlight
---@field set fun(self:Config.highlight.Hl, field: string, value: any):Config.highlight.Hl

---@class Config.highlight.Fn
---@field getter table<string, fun(opt: vim.api.keyset.highlight):vim.api.keyset.highlight>
---@field get_by_name fun(name: string): vim.api.keyset.highlight
return M
