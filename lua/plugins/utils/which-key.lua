return {
  "folke/which-key.nvim",
  event = "DeferredUIEnter",
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
        { "<leader>r", group = "rest", icon = { icon = "", color = "blue" } },
        { "<leader>a", group = "ai", icon = { icon = "", color = "blue" } },
        { "<leader>gh", group = "hunk" },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "z", group = "fold" },
      },
    },
  },
  after = function(spec)
    local wk = require "which-key"
    wk.setup(spec.opts)
    wk.add {
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
    }
  end,
}
