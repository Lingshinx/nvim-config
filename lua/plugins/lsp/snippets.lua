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
      local opts = {
        enable_autosnippets = false,
        ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = { { "", "Constant" } },
            },
          },
        },
      }

      luasnip.config.setup(opts)

      Snacks.toggle
        .new({
          id = "auto-snippet",
          name = "Auto Snippet",
          get = function() return opts.enable_autosnippets end,
          set = function(state)
            opts.enable_autosnippets = state
            luasnip.config.setup(opts)
          end,
        })
        :map "<leader>ut"
    end,
  },
}
