local M = {}

---@param path string
---@return string?
function M.realpath(path)
  if path == "" or path == nil then return nil end
  return vim.uv.fs_realpath(path) or path
end

---@param buf integer
---@return string?
function M.bufpath(buf) return M.realpath(vim.api.nvim_buf_get_name(assert(buf))) end

---@param pattern string
---@param path string
---@return boolean
function M.match(pattern, path)
  -- stylua: ignore
	return pattern == path or
    pattern:sub(1, 1) == "*" and
    path:find(vim.pesc(pattern:sub(2)) .. "$") ~= nil
end

return M
