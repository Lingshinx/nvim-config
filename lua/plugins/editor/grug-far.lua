return {
  "MagicDuck/grug-far.nvim",
  lazy = true,
  event = { "BufReadPre", "BufNewFile", "BufWritePre" },
  opts = {},
  keys = {
    {
      "<leader>sr",
      function()
        local ext = vim.bo.buftype == "" and vim.fn.expand "%:e"
        require("grug-far").open {
          transient = true,
          prefills = {
            filesFilter = ext and ext ~= "" and "*." .. ext or nil,
          },
        }
      end,
      mode = { "n", "x" },
      desc = "Search / Replace",
    },
  },
}
