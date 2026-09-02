return {
  { "esmuellert/codediff.nvim", cmd = "CodeDiff", load_before = "jj.nvim" },
  {
    "nicolasgb/jj.nvim",
    keys = {
      { "<leader>jj", function() require("jj.cmd").log() end, desc = "log" },
      { "<leader>jc", function() require("jj.cmd").commit() end, desc = "commit" },
      { "<leader>jd", function() require("jj.cmd").describe() end, desc = "describe" },
      { "<leader>jl", function() require("jj.cmd").log() end, desc = "log" },
      { "<leader>je", function() require("jj.cmd").edit() end, desc = "edit" },
      { "<leader>jn", function() require("jj.cmd").new() end, desc = "new" },
      { "<leader>jS", function() require("jj.cmd").status() end, desc = "status" },
      { "<leader>sj", function() require("jj.cmd").squash() end, desc = "squash" },
      { "<leader>ju", function() require("jj.cmd").undo() end, desc = "undo" },
      { "<leader>jy", function() require("jj.cmd").redo() end, desc = "redo" },
      { "<leader>jr", function() require("jj.cmd").rebase() end, desc = "rebase" },
      { "<leader>jbc", function() require("jj.cmd").bookmark_create() end, desc = "bookmark create" },
      { "<leader>jbd", function() require("jj.cmd").bookmark_delete() end, desc = "bookmark delete" },
      { "<leader>jbm", function() require("jj.cmd").bookmark_move() end, desc = "bookmark move" },
      { "<leader>jts", function() require("jj.cmd").tag_set() end, desc = "tag set" },
      { "<leader>jtd", function() require("jj.cmd").tag_delete() end, desc = "tag delete" },
      { "<leader>jtp", function() require("jj.cmd").tag_push() end, desc = "tag push" },
      { "<leader>ja", function() require("jj.cmd").abandon() end, desc = "abandon" },
      { "<leader>jf", function() require("jj.cmd").fetch() end, desc = "fetch" },
      { "<leader>jp", function() require("jj.cmd").push() end, desc = "push" },
      { "<leader>jD", function() require("jj.diff").open_vdiff() end, desc = "diff current buffer" },
      { "<leader>js", function() require("jj.picker").status() end, desc = "JJ Picker status" },
      { "<leader>jh", function() require("jj.picker").file_history() end, desc = "JJ Picker history" },
      { "<leader>jL", function() require("jj.cmd").log { revisions = "'all()'" } end, desc = "log all" },
    },
    opts = {
      terminal = {
        cursor_render_delay = 10, -- Adjust if cursor position isn't restoring correctly
      },
      diff = {
        backend = "codediff",
      },
      cmd = {
        describe = {
          editor = {
            type = "buffer",
            keymaps = {
              close = { "q", "<Esc>", "<C-c>" }, -- Enable <Esc> in the editor
            },
          },
        },
        bookmark = {
          prefix = "feat/",
        },
        keymaps = {
          log = {
            edit = "<CR>",
            describe = "d",
            diff = "<S-d>",
            abandon = "<S-a>",
            fetch = "<S-f>",
          },
          status = {
            open_file = "<CR>",
            restore_file = "<S-x>",
          },
          close = { "q", "<Esc>" },
        },
      },
      highlights = {
        editor = {
          modified = { fg = "#89ddff" },
        },
      },
    },
  },
}
