return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix",
    sort = { "local", "order", "group", "alphanum", "mod" },
    spec = {
      {
        mode = { "n", "v" },
        { "<leader><tab>", group = "tabs" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>q", group = "quit/session" },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
        { "<leader>x", group = "diag/quickfix", icon = { icon = "󱖫 ", color = "green" } },
        { "<leader>o", group = "overseer", icon = { icon = " ", color = "purple" } },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "z", group = "fold" },
        {
          "<leader>b",
          group = "buffer",
          expand = function() return require("which-key.extras").expand.buf() end,
        },
        {
          "<leader>w",
          group = "windows",
          proxy = "<c-w>",
          expand = function() return require("which-key.extras").expand.win() end,
        },
        -- better descriptions
        { "gx", desc = "Open with system app" },
      },
    },
  },
  keys = function()
    require("which-key").add {
      {
        "<leader>s?",
        require("which-key").show,
        desc = "Which key",
      },
      {
        "<leader>[",
        function() require("which-key").show { keys = "[", loop = true } end,
        desc = "Loop Prev",
        icon = "",
      },
      {
        "<leader>]",
        function() require("which-key").show { keys = "]", loop = true } end,
        desc = "Loop Next",
        icon = "",
      },
    }
  end,
}
