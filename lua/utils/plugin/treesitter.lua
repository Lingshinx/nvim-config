local after = require("utils.pack").after_wrap

return {
  ---@param langs string[]
  ensure_installed = after("nvim-treesitter", function(langs)
    local ts = require "nvim-treesitter"

    local installed = {}
    for lang in ipairs(ts.get_installed()) do
      installed[lang] = true
    end

    local not_installed = vim.iter(langs):filter(function(lang) return not installed[lang] end):totable()
    ts.install(not_installed)
  end),
}
