local fold = require("utils.list").fold

return {
  ---@param config config.language.Config
  ---@return table
  get_names = function(config)
    return fold({}, function(acc, cur)
      acc[#acc + 1] = type(cur) == "string" and cur or cur[1]
      return acc
    end, config)
  end,

  with_languages = function(cb)
    coroutine.wrap(function()
      local files = vim.api.nvim_get_runtime_file("langs/*.lua", true)
      cb(files)
    end)()
  end,

  diagnostic_goto = function(count, severity)
    return function()
      vim.diagnostic.jump {
        count = count,
        severity = severity and vim.diagnostic.severity[severity] or nil,
      }
    end
  end,
}
