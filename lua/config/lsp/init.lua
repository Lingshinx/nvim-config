require("config.lsp.config")

local M = {}
local list = require("config.utils.list")

local dir = vim.fn.stdpath("config") .. "/lua/config/langs"
local langs = {}

local files = vim.uv.fs_scandir(dir)
while files do
	local file, _ = vim.uv.fs_scandir_next(files)
	if not file then
		break
	end
	local name = file:sub(1, -5)
	local ok, mod = pcall(require, "config.langs." .. name)
	if ok then
		langs[name] = mod
	end
end

M.formattor = {}
M.treesitter = {}
M.mason = {}
M.lsp = {}

for key, value in pairs(langs) do
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
					vim.lsp.enable(v)
				elseif type(k) == "string" then
					list.append(M.mason, k)
					vim.lsp.config(k, v)
					vim.lsp.enable(k)
				end
			end
		end
	end
end

return M
