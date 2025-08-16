local M = {}
M = {
	---@param f fun(value):boolean
	---@param list any[]
	---@return boolean
	any = function(f, list)
		for _, item in ipairs(list) do
			if f(item) then
				return true
			end
		end
		return false
	end,

	---@param f fun(value):boolean
	---@param list any[]
	---@return boolean
	all = function(f, list)
		return not M.any(f, list)
	end,

	---@param list any[]
	---@param value any
	append = function(list, value)
		list[#list + 1] = value
	end,

	---@param f fun(a,b):boolean
	---@param list any[]
	maxBy = function(f, list)
		if vim.tbl_isempty(list) then
			return nil
		end

		local max = list[1]
		for _, value in ipairs(list) do
			if not f(max, value) then
				max = value
			end
		end
		return max
	end,
}
return M
