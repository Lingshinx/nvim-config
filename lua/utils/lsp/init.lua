require "config.lsp.config"

local langs = require("config.lsp.langs").new()

require("config.lsp.fn").foreach_lang(function(name, config) langs:solve(name, config) end)

langs:config()

return langs
