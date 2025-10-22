local M = {}

---@param path string?
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
  return pattern == path or pattern:sub(1, 1) == "*" and path:find(vim.pesc(pattern:sub(2)) .. "$") ~= nil
end

---@param dir string
---@param callback fun(file: string)
function M.ls(dir, callback)
  local files = vim.uv.fs_scandir(dir)
  while files do
    local file, _ = vim.uv.fs_scandir_next(files)
    if not file then break end
    callback(file)
  end
end

---@param rtp string
---@param modname string
---@param callback fun(name: string, mod: any)
function M.load_each(rtp, modname, callback)
  M.ls(rtp .. "/lua/" .. modname:gsub("%.", "/"), function(file)
    local name = file:sub(1, -5)
    local ok, mod = pcall(require, modname .. "." .. name)
    if ok then callback(name, mod) end
  end)
end

---@param path string
---@return string
function M.shorten_path(path, opts)
  opts = vim.tbl_extend("keep", opts or {}, {
    length = 2,
  })
  local parts = vim.split(path, "/")
  -- handle situation when path start with "/"
  parts = parts[1] == "" and { "", parts[2], "…", unpack(parts, #parts - opts.length + 2, #parts) }
    or { parts[1], "…", unpack(parts, #parts - opts.length + 2, #parts) }
  return #parts < opts.length and path or table.concat(parts, "/")
end

---@param path string
---@return string
function M.tilde(path)
  local home = vim.uv.os_homedir()
  return path:sub(1, #home) == home and "~" .. path:sub(#home + 1) or path
end

return M
