---@alias config.workspace.entry {name:string, type:"regular"|"directory"}
---@alias config.workspace.dir_handler fun(dir: string)
---@alias config.workspace.file_handler fun(value: any)

---@class config.workspace.HandlerOpts
---@field directory table<string, config.workspace.dir_handler>
---@field file table<string, config.workspace.dir_handler|boolean>

---@class config.workspace.Opts
---@field handlers config.workspace.HandlerOpts

local uv = vim.uv
local fs = require "utils.fs"

---@type config.workspace.Opts
local config = {
  handlers = {
    directory = {
      langs = require("utils.workspace.langs").handle_dir,
    },
    file = {
      lang = require("utils.workspace.langs").handle_file,
      debug = function(value) vim.print(value) end,
    },
  },
}

local function handle_each(dir, basename, filetype)
  local path = string.format("%s/%s", dir, basename)
  if filetype == "directory" then
    local handler = config.handlers["directory"][basename]
    if handler then handler(dir .. "/" .. basename) end
  elseif filetype == "file" and basename:sub(-4, -1) == ".lua" then
    local name = basename:sub(1, -5)
    local handler = config.handlers["file"][name]
    if handler then
      if type(handler) == "function" then
        handler(dofile(path))
      else
        dofile(path)
      end
    end
  end
end

local function detect_workspace(dir)
  dir = dir .. "/.nvim"
  uv.fs_stat(dir, function(err, stat)
    if err then return end
    if stat and stat.type == "directory" then
      fs.ls(dir, vim.schedule_wrap(function(file, type) handle_each(dir, file, type) end))
    end
  end)
end

return {
  setup = function(opts)
    config = vim.tbl_deep_extend("force", config, opts or {})
    local cwd = vim.uv.cwd()
    if cwd then detect_workspace(cwd) end

    vim.api.nvim_create_autocmd("DirChanged", {
      callback = function(event) detect_workspace(event.file) end,
    })
  end,
}
