---@param buf integer
---@return string?
local function bufpath(buf) return vim.uv.fs_realpath(vim.api.nvim_buf_get_name(buf)) end

---@param pattern string
---@param path string
---@return boolean
local function match(pattern, path)
  return pattern == path or pattern:sub(1, 1) == "*" and path:find(vim.pesc(pattern:sub(2)) .. "$") ~= nil
end

local M = {}
M = {
  ---@param buf integer
  ---@param bufpath string
  ---@return string?
  lsp = function(buf, bufpath) ---@diagnostic disable-line
    if not bufpath then return end
    local roots = {}
    local clients = vim.lsp.get_clients { bufnr = buf }
    for _, client in pairs(clients) do
      local workspace = client.config.workspace_folders
      for _, ws in pairs(workspace or {}) do
        roots[#roots + 1] = vim.uri_to_fname(ws.uri)
      end
      roots[#roots + 1] = client.root_dir
    end

    local longest_path = vim
      .iter(roots)
      :filter(function(path) return path and bufpath:find(path, 1, true) == 1 end)
      :fold("", function(acc, cur) return #cur > #acc and cur or acc end)
    if longest_path ~= "" then return longest_path end
  end,

  ---@param from string
  ---@param patterns string[]
  ---@return string?
  pattern = function(from, patterns)
    local result = vim.fs.find(function(path)
      return vim.iter(patterns):any(function(pattern) return match(pattern, path) end)
    end, {
      path = from or vim.uv.cwd(),
      upward = true,
    })[1]
    return result and vim.fs.dirname(result)
  end,

  ---@param path string
  ---@return string?
  parent = function(path) return vim.fn.fnamemodify(path, ":p:h") end,

  ---@param buf integer
  ---@return string?
  detect = function(buf)
    local name = bufpath(buf)
    if not name then return end
    return M.lsp(buf, name) or M.pattern(name, vim.g.root_pattern) or M.parent(name)
  end,

  cache = {},

  ---@return string
  get = function()
    local buf = vim.api.nvim_get_current_buf()
    local result = M.cache[buf]
    if result then return result end

    result = M.detect(buf) or vim.uv.cwd() or vim.env.HOME
    M.cache[buf] = result
    return result
  end,
}
return M
