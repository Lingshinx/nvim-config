local operators = {
  select = {
    { "x", "o" },
    function(query_string, query_group)
      require("nvim-treesitter-textobjects.select").select_textobject(query_string, query_group)
    end,
  },

  move = {
    { "n", "x", "o" },
    function(method, query_string, query_group)
      require("nvim-treesitter-textobjects.move")[method](query_string, query_group)
    end,
  },

  swap = {
    "n",
    function(method, query_string) require("nvim-treesitter-textobjects.swap")[method](query_string) end,
  },
}

local function mk_keymaps(config)
  local ret = {}
  for operator, argu in pairs(config) do
    local oper = operators[operator]
    for key, query in pairs(argu) do
      ret[#ret + 1] = {
        key,
        function() oper[2](unpack(query)) end,
        mode = oper[1],
      }
    end
  end
  return ret
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    branch = "main",
    build = ":TSUpdate",
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "<Up>", desc = "Increment Selection", mode = { "n", "x" } },
      { "<Down>", desc = "Decrement Selection", mode = "x" },
    },
    config = function() require("config.language"):config_treesitter() end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = { "LazyFile", "BufAdd" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    branch = "main",
    opts = {
      select = {
        lookahead = true,
      },
    },
    keys = mk_keymaps {
      swap = {
        ["<M-h>"] = { "swap_previous", "@parameter.inner" },
        ["<M-l>"] = { "swap_next", "@parameter.inner" },
      },
      select = {
        ["af"] = { "@function.outer", "textobjects" },
        ["if"] = { "@function.inner", "textobjects" },
        ["ac"] = { "@class.outer", "textobjects" },
        ["ic"] = { "@class.inner", "textobjects" },
        ["as"] = { "@local.scope", "locals" },
      },
      move = {
        ["[c"] = { "goto_previous_start", "@class.outer", "textobjects" },
        ["]c"] = { "goto_next_start", "@class.outer", "textobjects" },
        ["[C"] = { "goto_previous_end", "@class.outer", "textobjects" },
        ["]C"] = { "goto_next_end", "@class.outer", "textobjects" },

        ["[f"] = { "goto_previous_start", "@function.outer", "textobjects" },
        ["]f"] = { "goto_next_start", "@function.outer", "textobjects" },
        ["[F"] = { "goto_previous_end", "@function.outer", "textobjects" },
        ["]F"] = { "goto_next_end", "@function.outer", "textobjects" },

        ["[a"] = { "goto_previous_start", "@parameter.inner", "textobjects" },
        ["]a"] = { "goto_next_start", "@parameter.inner", "textobjects" },
        ["[A"] = { "goto_previous_end", "@parameter.inner", "textobjects" },
        ["]A"] = { "goto_next_end", "@parameter.inner", "textobjects" },

        ["[z"] = { "goto_previous_start", "@fold", "folds" },
        ["]z"] = { "goto_next_start", "@fold", "folds" },

        ["[s"] = { "goto_previous_start", "@local.scope", "locals" },
        ["]s"] = { "goto_next_start", "@local.scope", "locals" },
      },
    },
  },
}
