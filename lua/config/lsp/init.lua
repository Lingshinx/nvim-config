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

M.formatter = {}
M.treesitter = {}
M.mason = {}

local function config_lsp(lsp)
	if not lsp then
		return
	end

	if type(lsp) == "string" then
		list.append(M.mason, lsp)
	end
	if type(lsp) == "table" then
		for k, v in pairs(lsp) do
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

local function config_treesitter(lang, treesitter)
	if treesitter ~= false then
		list.append(M.treesitter, lang)
	end
end

local function config_formatter(lang, formatter)
	if not formatter then
		return
	end
	if type(formatter) == "table" then
		M.formatter[lang] = formatter
	elseif type(formatter) == "string" then
		M.formatter[lang] = { formatter }
	end
end

for lang, config in pairs(langs) do
	if config.enabled ~= false then
		config_formatter(lang, config.formatter)
		config_treesitter(lang, config.treesitter)
		config_lsp(config.lsp)
	end
end

return M
