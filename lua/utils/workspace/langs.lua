local Langs = require "utils.language.langs"
local fs = require "utils.fs"
local fn = require "utils.workspace.fn"
local is_file_in = fn.is_file_in

---@return boolean
local plugins_loaded = function()
  return require("utils.list").any(function(plugin) return package.loaded[plugin] end, {
    "conform",
    "nvim-treesitter",
    "mason",
  })
end

local function config_options(lang, opts)
  if not lang.options then return end
  local callback = function(event)
    local file = vim.api.nvim_buf_get_name(event and event.buf or 0)
    if not is_file_in(opts.root, file) then return end
    for opt, value in pairs(lang.options or {}) do
      vim.opt_local[opt] = value
    end
  end
  if vim.bo.filetype == lang.name then callback() end
  vim.api.nvim_create_autocmd("FileType", {
    pattern = lang.name,
    desc = string.format("Set options for filetype %s in workspace %s", lang.name, opts.root),
    callback = callback,
  })
end

local function config_langs(langs, opts)
  for _, lang in pairs(langs.get) do
    config_options(lang, opts)
  end
  langs:config { "lsp", "mason", "treesitter", "formatter" }
end

return {
  ---@type config.workspace.dir_handler
  handle_dir = function(dir, opts)
    local loaded = plugins_loaded()
    local langs = loaded and Langs.new() or require "config.language"
    fs.ls(dir, function(file, type)
      if type == "file" and file:sub(-4, -1) == ".lua" then
        local name = file:sub(1, -5)
        local config = dofile(dir .. "/" .. file)
        if not config[1] then config[1] = name end
        langs:solve(config)
      end
    end, loaded and vim.schedule_wrap(function() config_langs(langs, opts) end) or nil)
  end,

  ---@type config.workspace.file_handler
  handle_file = function(config, opts)
    local loaded = plugins_loaded()
    local langs = loaded and Langs.new() or require "config.language"
    if not config[1] then return end
    langs:solve(config)
    if loaded then config_langs(langs, opts) end
  end,
}
