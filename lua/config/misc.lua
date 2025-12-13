local toggles = require "utils.format"

toggles.format:map "<leader>uf"
toggles.format_global:map "<leader>uF"

require("utils.cliapend").setup { keymap = { paste_prefix = "g" } }
