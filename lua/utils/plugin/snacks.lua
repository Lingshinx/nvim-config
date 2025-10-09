return {
  ---@param name string
  ---@param opts snacks.picker.Config?
  ---@return fun(opts: snacks.picker.Config?):snacks.Picker
  picker = function(name, opts)
    if Snacks.picker[name] then return opts and function() Snacks.picker[name](opts) end or Snacks.picker[name] end
    local ok, value = pcall(require, "config.pickers." .. name)
    if ok then
      value = type(value) == "table" and vim.tbl_extend("force", value, opts or {}) or value(opts)
      local picker = function() Snacks.picker.pick(value) end
      Snacks.picker[name] = picker
      return picker --[[@as fun(opts: snacks.picker.Config?):snacks.Picker]]
    else
      error("No picker named " .. name)
    end
  end,

  ---@param count integer
  ---@param cycle boolean?
  ---@return fun()
  word_goto = function(count, cycle)
    return function() Snacks.words.jump(count, cycle) end
  end,
}
