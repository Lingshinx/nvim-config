require("config.langs.lsp")
local M = {}
local list = require("config.utils.list")

M.formattor = {}
M.treesitter = {}
M.mason = {}
M.lsp = {}

for key, value in pairs(require("config.langs.config")) do
	local formattor = value.formattor
	if formattor then
		if type(formattor) == "table" then
			M.formattor[key] = formattor
		elseif type(formattor) == "string" then
			M.formattor[key] = { formattor }
		end
	end

	if value.treesitter ~= false then
		list.append(M.treesitter, key)
	end

	if value.lsp then
		if type(value.lsp) == "string" then
			list.append(M.mason, value.lsp)
		end
		if type(value.lsp) == "table" then
			for k, v in pairs(value.lsp) do
				if type(k) == "number" then
					list.append(M.mason, v)
				elseif type(k) == "string" then
					list.append(M.mason, k)
					vim.lsp.config(k, v)
				end
			end
		end
	end
end

return M
