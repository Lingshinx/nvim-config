---@alias config.workspace.entry {name:string, type:"regular"|"directory"}
---@alias config.workspace.dir_handler fun(dir: string, opts?: config.workspace.hander.Opts)
---@alias config.workspace.file_handler fun(value: any, opts?: config.workspace.hander.Opts)

---@class config.workspace.hander.Opts
---@field root string
---@field dir string
---@field path string

---@class config.workspace.handler.Config
---@field directory table<string, config.workspace.dir_handler>
---@field file table<string, config.workspace.dir_handler|boolean>

---@class config.workspace.Opts
---@field handlers config.workspace.handler.Config
---@field dir string

local uv = vim.uv
local fs = require "utils.fs"

---@type config.workspace.Opts
local config = {
  dir = ".nvim",
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

local function handle_each(basename, filetype, opts)
  local dir = opts.dir
  local root = opts.root
  local path = string.format("%s/%s/%s", root, dir, basename)
  opts.path = path
  if filetype == "directory" then
    local handler = config.handlers["directory"][basename]
    if handler then handler(path, opts) end
  elseif filetype == "file" and basename:sub(-4, -1) == ".lua" then
    local name = basename:sub(1, -5)
    local handler = config.handlers["file"][name]
    if handler then
      if type(handler) == "function" then
        handler(dofile(path), opts)
      else
        dofile(path)
      end
    end
  end
end

local function detect_workspace(root)
  local dot_nvim = string.format("%s/%s", root, config.dir)
  uv.fs_stat(dot_nvim, function(err, stat)
    if err then return end
    if stat and stat.type == "directory" then
      fs.ls(
        dot_nvim,
        vim.schedule_wrap(
          function(file, type)
            handle_each(file, type, {
              root = root,
              dir = config.dir,
            })
          end
        )
      )
    end
  end)
end

local loaded = {}

return {
  setup = function(opts)
    config = vim.tbl_deep_extend("force", config, opts or {})
    local cwd = vim.uv.cwd()
    if cwd then
      loaded[cwd] = true
      detect_workspace(cwd)
    end

    vim.api.nvim_create_autocmd("DirChanged", {
      callback = function(event)
        local file = event.file
        if loaded[file] then return end
        loaded[file] = true
        detect_workspace(event.file)
      end,
    })
  end,
}
