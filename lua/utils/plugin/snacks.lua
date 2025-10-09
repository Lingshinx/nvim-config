for key, value in pairs(require "utils.plugin.pickers") do
  if type(value) == "table" then
    Snacks.picker[key] = function(opts) Snacks.picker.pick(vim.tbl_extend("force", value, opts or {})) end
  elseif type(value) == "function" then
    Snacks.picker[key] = function(opts) Snacks.picker.pick(value(opts)) end
  end
end

return {
  ---@param name string
  ---@param opts snacks.picker.Config?
  ---@return fun(opts: snacks.picker.Config?):snacks.Picker
  picker = function(name, opts)
    return opts and function() Snacks.picker[name](opts) end or Snacks.picker[name]
  end,

  ---@param count integer
  ---@param cycle boolean?
  ---@return fun()
  word_goto = function(count, cycle)
    return function() Snacks.words.jump(count, cycle) end
  end,
}
