return {
  Lang = require "utils.language.lang",
  Langs = require "utils.language.langs",

  ---@param hook? fun(langs: config.language.Langs)
  setup = function(hook)
    local langs = require("utils.language.langs").new()

    require("utils.language.fn").with_languages(function(files)
      for _, file in ipairs(files) do
        local name = vim.fn.fnamemodify(file, ":t:r")
        local config = dofile(file)
        if not config[1] then config[1] = name end
        langs:solve(config)
      end
      langs.ok = true
      if hook then hook(langs) end
    end)

    return langs
  end,
}
