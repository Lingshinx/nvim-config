return {
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    version = "v2.*",
    config = function()
      local types = require "luasnip.util.types"
      local luasnip = require "luasnip"
      require("luasnip.loaders.from_lua").lazy_load { paths = vim.fn.stdpath "config" .. "/snippet/lua/" }
      require("luasnip.loaders.from_vscode").lazy_load()
      luasnip.config.setup {
        ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = { { "", "Constant" } },
            },
          },
        },
      }
    end,
  },
}
