local Langs = require "utils.language.langs"
local fs = require "utils.fs"

---@return boolean
local plugins_loaded = function()
  return require("utils.list").any(function(plugin) return package.loaded[plugin] end, {
    "conform",
    "nvim-treesitter",
    "mason",
  })
end

return {
  ---@type config.workspace.dir_handler
  handle_dir = function(dir)
    vim.print "hello"
    local loaded = plugins_loaded()
    local langs = loaded and Langs.new() or require "config.language"
    fs.ls(dir, function(file, type)
      if type == "file" and file:sub(-4, -1) == ".lua" then
        local name = file:sub(1, -5)
        local config = dofile(dir .. "/" .. file)
        if not config[1] then config[1] = name end
        langs:solve(config)
      end
    end, loaded and function() langs:config() end or nil)
  end,

  ---@type config.workspace.file_handler
  handle_file = function(config)
    local loaded = plugins_loaded()
    local langs = loaded and Langs.new() or require "config.language"
    if not config[1] then return end
    langs:solve(config)
    if loaded then langs:config() end
  end,
}
