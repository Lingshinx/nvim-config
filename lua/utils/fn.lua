local M = {}
M = {
  ---@param f fun(x):integer
  ---@return fun(a, b):boolean
  comparing = function(f)
    return function(a, b) return f(a) < f(b) end
  end,

  ---@param str string
  ---@return integer
  length = function(str) return str and #str or 0 end,

  ---@param str string
  ---@return string
  capitalize = function(str) return str:sub(1, 1):upper() .. str:sub(2) end,

  ---@param str string
  ---@param length integer
  ---@param tail string
  truncate = function(str, length, tail)
    if #str <= length then return str end
    return str:sub(1, length - #tail) .. tail
  end,

  ---@param callback fun()
  deter = function(callback)
    vim.api.nvim_create_autocmd("UIEnter", {
      callback = callback,
    })
  end,
}
return M
