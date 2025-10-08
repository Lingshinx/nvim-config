local fold = require("config.utils.list").fold

return {
  ---@param callback fun(name: string, mod:Config.LangConfig)
  foreach_lang = function(callback)
    require("config.utils.fs").load_each(
      vim.fn.stdpath "config",
      "config.langs",
      function(name, mod) callback(name, mod) end
    )
  end,

  ---@param config Config.LangConfig
  ---@return table?
  get_names = function(config)
    return fold({}, function(acc, cur)
      acc[#acc + 1] = type(cur) == "string" and cur or cur[1]
      return acc
    end, config)
  end,
}
