return {
  -- "Lingshinx/trans-hover.nvim",
  dir = "~/Desktop/Workspace/Lua/trans-nvim",
  opts = {
    translator = "trans.md",
    sentence_translator = { "trans", "-b" },
    sentence_viewer = "hover",
  },
  cmd = { "Trans", "TransToggle" },
  dependencies = { "folke/noice.nvim" }, -- optional
  keys = {
    { "<leader>ut", "<cmd>TransToggle<CR>", desc = "toggle trans" },
  },
}
