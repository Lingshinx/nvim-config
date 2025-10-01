require "config.lsp.config"

local M = {}
local list = require "config.utils.list"

-- collect all lang files in dir below
local dir = vim.fn.stdpath "config" .. "/lua/config/langs"
local langs = {}
-- gather all language informations
local files = vim.uv.fs_scandir(dir)
while files do
  local file, _ = vim.uv.fs_scandir_next(files)
  if not file then break end
  local name = file:sub(1, -5) -- throw '.lua' away
  local ok, mod = pcall(require, "config.langs." .. name)
  if ok then
    if mod[1] == nil then
      langs[name] = mod
    else
      for _, lang in ipairs(mod) do
        if type(lang) == "string" then
          langs[lang] = mod
        elseif type(lang) == "table" and type(lang[1]) == "string" then
          langs[lang[1]] = vim.tbl_extend("keep", lang, mod)
        end
      end
    end
  end
end

M.formatter = {}
M.treesitter = {}
M.lsp = {}
M.plugins = {}

local function config_lsp(lsp)
  if not lsp then return end

  if type(lsp) == "string" then
    list.append(M.lsp, lsp)
  elseif type(lsp) == "table" then
    for k, v in pairs(lsp) do
      if type(k) == "number" then
        list.append(M.lsp, v)
      elseif type(k) == "string" then
        list.append(M.lsp, k)
        vim.lsp.config(k, v)
      end
    end
  end

  for _, lang_servers in ipairs(M.lsp) do
    vim.lsp.enable(lang_servers)
  end
end

local function config_plugins(plugins)
  if plugins then list.append(M.plugins, plugins) end
end

local function config_treesitter(lang, treesitter)
  if type(treesitter) == "table" then
    vim.list_extend(M.treesitter, treesitter)
  elseif type(treesitter) == "string" then
    list.append(M.treesitter, treesitter)
  elseif treesitter ~= false then
    list.append(M.treesitter, lang)
  end
end

local function config_formatter(lang, formatter)
  if not formatter then return end
  if type(formatter) == "table" then
    M.formatter[lang] = formatter
  elseif type(formatter) == "string" then
    M.formatter[lang] = { formatter }
  end
end

for lang, config in pairs(langs) do
  if config.enabled ~= false then
    config_plugins(config.plugins)
    config_lsp(config.lsp)
    config_treesitter(lang, config.treesitter)
    config_formatter(lang, config.formatter)
  end
end

return M
