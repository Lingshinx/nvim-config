local picker = require("utils.plugin.snacks").picker
require("which-key").add {
  { "<leader>gd", picker "git_diff", desc = "Diff" },
  { "<leader>gs", picker "git_status", desc = "Status" },
  { "<leader>gS", picker "git_stash", desc = "Stash" },
  -- git
  {
    "<leader>gg",
    function() Snacks.lazygit() end,
    desc = "Lazygit",
  },
  { "<leader>gf", picker "git_log_file", desc = "File History" },
  { "<leader>gl", picker "git_log", desc = "Log" },

  { "<leader>gb", picker "git_log_line", desc = "Blame" },
  {
    "<leader>gB",
    function() Snacks.gitbrowse() end,
    mode = { "n", "x" },
    desc = "Browse Open",
  },
  {
    "<leader>gY",
    function()
      Snacks.gitbrowse {
        open = function(url) vim.fn.setreg("+", url) end,
        notify = false,
      }
    end,
    desc = "Browse Copy",
  },
}
