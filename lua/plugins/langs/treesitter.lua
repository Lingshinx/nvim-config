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
        desc = query.desc,
      }
    end
  end
  return ret
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile", "BufWritePre" },
    cmd = { "TSInstall", "TSInstallFromGrammar", "TSLog", "TSUninstall", "TSUpdate" },
  },

  {
    "Lingshinx/treesitter-select.nvim",
    keys = {
      {
        "<UP>",
        "<Plug>(TreesitterSelectParent)",
        mode = { "n", "x" },
        desc = "increment Selection",
      },
      {
        "<Down>",
        "<Plug>(TreesitterSelectChild)",
        mode = "x",
        desc = "Decrement Selection",
      },
      {
        "<Left>",
        "<Plug>(TreesitterSelectPrev)",
        mode = "x",
        desc = "Prev Selection",
      },
      {
        "<Right>",
        "<Plug>(TreesitterSelectNext)",
        mode = "x",
        desc = "Next Selection",
      },
      {
        "<Home>",
        "<Plug>(TreesitterSelectFirst)",
        mode = "x",
        desc = "Prev Selection",
      },
      {
        "<End>",
        "<Plug>(TreesitterSelectLast)",
        mode = "x",
        desc = "Next Selection",
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    main = "nvim-treesitter-textobjects",
    event = { "BufReadPre", "BufNewFile", "BufWritePre" },
    opts = {
      select = {
        lookahead = true,
      },
    },
    keys = mk_keymaps {
      swap = {
        ["<M-h>"] = { "swap_previous", "@parameter.inner", desc = "Swap prev parameter" },
        ["<M-l>"] = { "swap_next", "@parameter.inner", desc = "Swap next parameter" },
      },
      select = {
        ["af"] = { "@function.outer", "textobjects" },
        ["if"] = { "@function.inner", "textobjects" },
        ["ac"] = { "@class.outer", "textobjects" },
        ["ic"] = { "@class.inner", "textobjects" },
        ["as"] = { "@local.scope", "locals" },
      },
      move = {
        ["[c"] = { "goto_previous_start", "@class.outer", "textobjects", desc = "Prev Class Start" },
        ["]c"] = { "goto_next_start", "@class.outer", "textobjects", desc = "Next Class Start" },
        ["[C"] = { "goto_previous_end", "@class.outer", "textobjects", desc = "Prev Class End" },
        ["]C"] = { "goto_next_end", "@class.outer", "textobjects", desc = "Nex Class End" },

        ["[f"] = { "goto_previous_start", "@function.outer", "textobjects", desc = "Prev Function Start" },
        ["]f"] = { "goto_next_start", "@function.outer", "textobjects", desc = "Next Function Start" },
        ["[F"] = { "goto_previous_end", "@function.outer", "textobjects", desc = "Prev Function End" },
        ["]F"] = { "goto_next_end", "@function.outer", "textobjects", desc = "Prev Function End" },

        ["[a"] = { "goto_previous_start", "@parameter.inner", "textobjects", desc = "Prev Parameter Start" },
        ["]a"] = { "goto_next_start", "@parameter.inner", "textobjects", desc = "Next Parameter Start" },
        ["[A"] = { "goto_previous_end", "@parameter.inner", "textobjects", desc = "Prev Parameter End" },
        ["]A"] = { "goto_next_end", "@parameter.inner", "textobjects", desc = "Prev Parameter End" },

        ["[z"] = { "goto_previous_start", "@fold", "folds", desc = "Prev Fold" },
        ["]z"] = { "goto_next_start", "@fold", "folds", desc = "Next Fold" },

        ["[s"] = { "goto_previous_start", "@local.scope", "locals", desc = "Prev Scope" },
        ["]s"] = { "goto_next_start", "@local.scope", "locals", desc = "Next Scope" },
      },
    },
  },
}
