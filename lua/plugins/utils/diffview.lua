return {
  "dlyongemallo/diffview-plus.nvim",
  main = "diffview",
  opts = {
    keymaps = {
      view = {
        ["<C-c>"] = "<Cmd>DiffviewClose<CR>",
      },
      file_panel = {
        ["<C-c>"] = "<Cmd>DiffviewClose<CR>",
      },
      file_history_panel = {
        ["<C-c>"] = "<Cmd>DiffviewClose<CR>",
      },
    },
  },
  cmd = {
    "DiffviewOpen",
    "DiffviewToggle",
    "DiffviewFileHistory",
    "DiffviewDiffFiles",
    "DiffviewLog",
  },
}
