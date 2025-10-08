for key, value in pairs(require "utils.plugin.pickers") do
  if type(value) == "table" then
    Snacks.picker[key] = function(opts) Snacks.picker.pick(vim.tbl_extend("force", value, opts or {})) end
  elseif type(value) == "function" then
    Snacks.picker[key] = function(opts) Snacks.picker.pick(value(opts)) end
  end
end

return function(name, opts)
  return opts and function() Snacks.picker[name](opts) end or Snacks.picker[name]
end
