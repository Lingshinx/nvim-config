return {
  "cbochs/grapple.nvim",
  dependencies = {
    "nvim-mini/mini.icons",
    config = function()
      require("mini.icons").setup()
      MiniIcons.mock_nvim_web_devicons()
    end,
  },
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
    tag_hook = require("utils.plugin.grapple").tag_hook,
  },
  keys = {
    { "'", function() require("grapple").toggle_tags() end, desc = "Toggle tags menu" },
    {
      "m",
      function()
        require("grapple").toggle()
        vim.api.nvim_exec_autocmds("User", { pattern = "GrappleToggled" })
      end,
      desc = "Tag a file",
    },
  },
}
