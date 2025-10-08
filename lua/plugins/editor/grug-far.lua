return {
  "MagicDuck/grug-far.nvim",
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
      mode = { "n", "v" },
      desc = "Search / Replace",
    },
  },
}
