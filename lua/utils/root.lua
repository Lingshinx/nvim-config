local fn = require "utils.fn"
local fs = require "utils.fs"
local list = require "utils.list"
local M = {}
M = {
  ---@param buf integer
  ---@return string?
  lsp = function(buf)
    local bufpath = fs.bufpath(buf)
    if not bufpath then return nil end
    local roots = {}
    local clients = vim.lsp.get_clients { bufnr = buf }
    for _, client in pairs(clients) do
      local workspace = client.config.workspace_folders
      for _, ws in pairs(workspace or {}) do
        list.append(roots, vim.uri_to_fname(ws.uri))
      end
      list.append(roots, client.root_dir)
    end
    return list.maxBy(
      fn.comparing(fn.length),
      vim.tbl_filter(function(path) return path and bufpath:find(path, 1, true) == 1 end, roots)
    )
  end,

  ---@param buf integer
  ---@param patterns string[]
  ---@return string?
  pattern = function(buf, patterns)
    local result = vim.fs.find(function(path)
      return list.any(function(pattern) return fs.match(pattern, path) end, patterns)
    end, {
      path = fs.bufpath(buf) or vim.uv.cwd(),
      upward = true,
    })[1]
    return result and vim.fs.dirname(result)
  end,

  ---@param buf integer
  ---@return string?
  parent = function(buf)
    local path = vim.api.nvim_buf_get_name(buf)
    if vim.fn.filereadable(path) == 0 then return end
    local parent = vim.fn.fnamemodify(path, ":p:h")
    return vim.uv.fs_stat(parent) and parent or nil
  end,

  ---@param buf integer
  ---@return string?
  detect = function(buf) return M.lsp(buf) or M.pattern(buf, vim.g.root_pattern) or M.parent(buf) or vim.uv.cwd() end,

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
