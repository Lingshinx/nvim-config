local fold = require("utils.list").fold

return {
  ---@param config Config.LangConfig
  ---@return table
  get_names = function(config)
    return fold({}, function(acc, cur)
      acc[#acc + 1] = type(cur) == "string" and cur or cur[1]
      return acc
    end, config)
  end,

  ---@param name string
  ---@return string
  get_path = function(name) return vim.fn.stdpath "config" .. "/lua/config/langs/" .. name .. ".lua" end,

  diagnostic_goto = function(count, severity)
    return function()
      vim.diagnostic.jump {
        count = count,
        severity = severity and vim.diagnostic.severity[severity] or nil,
      }
    end
  end,
}
