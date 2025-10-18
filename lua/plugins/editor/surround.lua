return {
  "kylechui/nvim-surround",
  version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
  event = "VeryLazy",
  opts = {
    keymaps = {
      insert = "<C-g>s",
      insert_line = "<C-g>S",
      normal = "sa",
      normal_cur = "saa",
      normal_line = "sA",
      normal_cur_line = "sao",
      visual = "sa",
      visual_line = "sA",
      delete = "sd",
      change = "sr",
      change_line = "sR",
    },
  },
}
