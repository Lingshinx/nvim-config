local M = {}
---@type fun(name: string): vim.api.keyset.get_hl_info
function M.get_by_name(name) return vim.api.nvim_get_hl(0, { name = name, link = false }) end

---@type table<string, fun(opt: vim.api.keyset.highlight):vim.api.keyset.highlight>
M.setter = setmetatable({}, {
  __index = function(_, index)
    return function(value) return vim.tbl_extend("force", M.get_by_name(index), value) end
  end,
})
---@type table<string, vim.api.keyset.highlight>
M.getter = setmetatable({}, {
  __index = function(_, index) return M.get_by_name(index) end,
})

return M
