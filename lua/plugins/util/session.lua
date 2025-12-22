-- Lua
return {
  "folke/persistence.nvim",
  event = "BufReadPre", -- this will only start session saving when an actual file was opened
  -- load the session for the current directory
  keys = {
    { "<leader>qs", function() require("persistence").select() end, desc = "Select" },
    { "<leader>ql", function() require("persistence").load { last = true } end, desc = "Last" },
  },
  opts = {
    need = 5,
  },
}
