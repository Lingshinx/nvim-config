local after = require("utils.pack").after_wrap
local contains_map = require("utils.fn").contains_map

return {
  ---@param langs string[]
  ensure_installed = after("nvim-treesitter", function(langs)
    local ts = require "nvim-treesitter"
    local installed = contains_map(ts.get_installed())
    local not_installed = vim.iter(langs):filter(function(lang) return not installed[lang] end):totable()
    ts.install(not_installed)
  end),
}
