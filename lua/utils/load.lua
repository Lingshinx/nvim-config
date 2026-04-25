local M = {}

---@param dir string
---@param opts {foreach: fun(file: string)?, after: fun()?}
local function ls_normal(dir, opts)
  vim.uv.fs_scandir(dir, function(err, files)
    if err then return end
    while files do
      local file, type = vim.uv.fs_scandir_next(files)
      if not file then return end
      if type == "file" then opts.foreach(vim.fs.joinpath(dir, file)) end
    end
    if opts.after then opts.after() end
  end)
end

---@param dir string
---@param foreach fun(file: string)
local function ls_recursive(dir, foreach)
  vim.uv.fs_scandir(dir, function(err, files)
    if err then return end
    while files do
      local file, type = vim.uv.fs_scandir_next(files)
      if not file then break end
      if type == "file" then
        foreach(vim.fs.joinpath(dir, file))
      elseif type == "directory" then
        ls_recursive(vim.fs.joinpath(dir, file), foreach)
      end
    end
  end)
end

---@param dir string
---@param opts {foreach: fun(file: string), after: fun(), count: integer}
local function ls_after(dir, opts)
  opts.count = opts.count + 1
  vim.uv.fs_scandir(dir, function(err, files)
    if err then return end
    while files do
      local file, type = vim.uv.fs_scandir_next(files)
      if not file then break end
      if type == "file" then
        opts.foreach(vim.fs.joinpath(dir, file))
      elseif type == "directory" then
        ls_after(vim.fs.joinpath(dir, file), opts)
      end
    end
    opts.count = opts.count - 1
    if opts.count == 0 then opts.after() end
  end)
end

---@param dir string
---@param opts {foreach: fun(file: string)?, after: fun()?, recursive: boolean}
function M.ls(dir, opts)
  if not opts.foreach and opts.after then
    local files, index, after = {}, 0, opts.after
    opts.after = function() after(files) end ---@diagnostic disable-line
    opts.foreach = function(file)
      index = index + 1
      files[index] = file
    end
  end
  if not opts.recursive then
    ls_normal(dir, opts)
  elseif opts.after then
    opts.count = 0 ---@diagnostic disable-line
    ls_after(dir, opts) ---@diagnostic disable-line
  else
    ls_recursive(dir, opts.foreach)
  end
end

---@param dir string
---@param opts {foreach: fun(value: any, name: string), after: fun()?, recursive: boolean}
function M.load_each(dir, opts)
  M.ls(dir, {
    foreach = function(file)
      local name = file:sub(1, -5)
      opts.foreach(dofile(file), name)
    end,
    after = opts.after,
    recursive = opts.recursive,
  })
end

---@param opts {timeout: integer, interval: integer, fast_only: boolean}?
---@return fun() signal, fun() wait
function M.mk_waiter(opts)
  opts = opts or {}
  local flag = false
  local function signal() flag = true end
  local function wait()
    vim.wait(opts.timeout or 1000, function() return flag end, opts.interval or 20, opts.fast_only ~= false)
  end
  return signal, wait
end

return M
