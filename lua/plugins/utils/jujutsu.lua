return {
  {
    "dlyongemallo/diffview-plus.nvim",
    load_before = "jj.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewToggle",
      "DiffviewFileHistory",
      "DiffviewDiffFiles",
      "DiffviewLog",
    },
  },
  {
    "nicolasgb/jj.nvim",
    keys = {
      { "<leader>jj", function() require("jj.cmd").log() end, desc = "log" },
      { "<leader>jc", function() require("jj.cmd").commit() end, desc = "commit" },
      { "<leader>jd", function() require("jj.cmd").describe() end, desc = "describe" },
      { "<leader>jl", function() require("jj.cmd").log() end, desc = "log" },
      { "<leader>jn", function() require("jj.cmd").new() end, desc = "new" },
      { "<leader>js", function() require("jj.cmd").status() end, desc = "status" },
      { "<leader>ju", function() require("jj.cmd").undo() end, desc = "undo" },
      { "<leader>jy", function() require("jj.cmd").redo() end, desc = "redo" },
      { "<leader>jbc", function() require("jj.cmd").bookmark_create() end, desc = "bookmark create" },
      { "<leader>jbd", function() require("jj.cmd").bookmark_delete() end, desc = "bookmark delete" },
      { "<leader>jbm", function() require("jj.cmd").bookmark_move() end, desc = "bookmark move" },
      { "<leader>jts", function() require("jj.cmd").tag_set() end, desc = "tag set" },
      { "<leader>jtd", function() require("jj.cmd").tag_delete() end, desc = "tag delete" },
      { "<leader>jtp", function() require("jj.cmd").tag_push() end, desc = "tag push" },
      { "<leader>jf", function() require("jj.cmd").fetch() end, desc = "fetch" },
      { "<leader>jp", function() require("jj.cmd").push() end, desc = "push" },
      { "<leader>jD", function() require("jj.diff").open_vdiff() end, desc = "diff current buffer" },
      { "<leader>jh", function() require("jj.picker").file_history() end, desc = "JJ Picker history" },
      { "<leader>jL", function() require("jj.cmd").log { revisions = "all()" } end, desc = "log all" },
    },
    opts = {
      terminal = {
        cursor_render_delay = 10, -- Adjust if cursor position isn't restoring correctly
        window = {
          floating_width = 0.8, -- Width % of the floating window (between 0.1 and 1.0)
          floating_height = 0.85, -- Height % of the floating window (between 0.1 and 1.0)
        },
      },
      diff = { backend = "diffview" },
      cmd = {
        keymaps = {
          log = {
            describe = "cc",
            abandon = "dd",
            new = "o",
            open_pr = false,
            open_pr_list = false,
          },
        },
      },
    },
  },
}
