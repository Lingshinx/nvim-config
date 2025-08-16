local M = {}
M = {
	---@param f fun(x):integer
	---@return fun(a, b):boolean
	comparing = function(f)
		return function(a, b)
			return f(a) < f(b)
		end
	end,

	---@param str string
	---@return integer
	length = function(str)
		return str and #str or 0
	end,
}
return M
