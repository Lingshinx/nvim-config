local M = {}
M = {
  ---@param f fun(value):boolean
  ---@param list any[]
  ---@return boolean
  any = function(f, list)
    for _, item in ipairs(list) do
      if f(item) then return true end
    end
    return false
  end,

  ---@generic A
  ---@generic B
  ---@param init A
  ---@param f fun(acc:A, cur:B, idx: number):A
  ---@param list B[]
  ---@return A
  fold = function(init, f, list)
    if type(init) == "table" then
      for i, v in ipairs(list) do
        f(init, v, i)
      end
    else
      for i, v in ipairs(list) do
        init = f(init, v, i)
      end
    end
    return init
  end,

  ---@generic A
  ---@generic B
  ---@generic C
  ---@param init A
  ---@param f fun(acc:A, cur_var: C, cur_key: B):A
  ---@param table table<B,C>
  ---@return A
  mapfold = function(init, f, table)
    if type(init) == "table" then
      for k, v in pairs(table) do
        f(init, v, k)
      end
    else
      for k, v in pairs(table) do
        init = f(init, v, k)
      end
    end
    return init
  end,

  ---@param f fun(value):boolean
  ---@param list any[]
  ---@return boolean
  all = function(f, list) return not M.any(f, list) end,

  ---@param list any[]
  ---@param value any
  append = function(list, value) list[#list + 1] = value end,

  ---@param f fun(a,b):boolean
  ---@param list any[]
  maxBy = function(f, list)
    if vim.tbl_isempty(list) then return nil end

    local max = list[1]
    for _, value in ipairs(list) do
      if not f(max, value) then max = value end
    end
    return max
  end,
}
return M
