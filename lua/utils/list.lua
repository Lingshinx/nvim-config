local M = {}
M = {
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
}
return M
