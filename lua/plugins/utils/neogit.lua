return {
  { "esmuellert/codediff.nvim", cmd = "CodeDiff", load_before = "neogit" },
  { "m00qek/baleia.nvim", load_before = "neogit" },
  { "folke/snacks.nvim", load_before = "neogit" },
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    opts = {
      disable_hint = true,
      graph_style = "kitty",
    },
    keys = {
      { "<Plug>(ConfigGit)", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
    },
  },
}
