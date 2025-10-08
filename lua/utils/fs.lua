local M = {}

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

return M
