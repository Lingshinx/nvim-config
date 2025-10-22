return {
  "cbochs/grapple.nvim",
  dependencies = { { "nvim-tree/nvim-web-devicons", lazy = true } },
  ---@type grapple.settings
  opts = {
    scope = "cwd", -- also try out "git_branch"
    style = "basename",
    quick_select = "1234567890",
    prune = "30m",
    win_opts = {
      width = 40,
      border = "rounded",
    },
  },
  keys = {
    { "'", function() require("grapple").toggle_tags() end, desc = "Toggle tags menu" },
    {
      "m",
      function()
        require("grapple").toggle()
        vim.schedule(function() vim.cmd.redraw { bang = true } end)
      end,
      desc = "Tag a file",
    },
  },
}
