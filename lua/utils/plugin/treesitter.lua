return {
  ---@param langs string[]
  ensure_installed = function(langs)
    local installed = {}
    for f in vim.fs.dir(require("nvim-treesitter.config").get_install_dir "parser") do
      installed[vim.fn.fnamemodify(f, ":r")] = true
    end
    local not_installed = vim.iter(langs):filter(function(lang) return not installed[lang] end):totable()
    require("nvim-treesitter").install(not_installed)
  end,
}
