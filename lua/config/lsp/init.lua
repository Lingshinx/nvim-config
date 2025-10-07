require "config.lsp.config"

local langs = require("config.lsp.langs").new()
local dir = vim.fn.stdpath "config" .. "/lua/config/langs"

require("config.utils.fs").ls(dir, function(file)
  local name = file:sub(1, -5) -- throw '.lua' away
  local ok, mod = pcall(require, "config.langs." .. name)
  if ok then
    if mod[1] == nil then
      langs:append(name, mod)
    else
      for _, lang in ipairs(mod) do
        if type(lang) == "string" then
          langs:append(lang, mod)
        elseif type(lang) == "table" and type(lang[1]) == "string" then
          langs:append(lang[1], vim.tbl_extend("keep", lang, mod))
        end
      end
    end
  end
end)

langs:config()

return langs
