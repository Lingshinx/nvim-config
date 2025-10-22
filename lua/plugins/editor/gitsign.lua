local signs = {
  add = { text = "▎" },
  change = { text = "▎" },
  delete = { text = "" },
  topdelete = { text = "" },
  changedelete = { text = "▎" },
  untracked = { text = "▎" },
}

return {
  "lewis6991/gitsigns.nvim",
  event = "LazyFile",
  opts = {
    signs = signs,
    signs_staged = signs,
    on_attach = function(buffer)
      local gitsign = require "gitsigns"

      local function map(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc, silent = true }) end

      map("n", "<leader>ghu", gitsign.undo_stage_hunk, "Undo")
      map("n", "<leader>ghs", gitsign.stage_hunk, "Stage")
      map("n", "<leader>ghr", gitsign.reset_hunk, "Reset ")
      map("v", "<leader>ghs", function() gitsign.stage_hunk { vim.fn.line ".", vim.fn.line "v" } end)
      map("v", "<leader>ghr", function() gitsign.reset_hunk { vim.fn.line ".", vim.fn.line "v" } end)

      map("n", "<leader>ghS", gitsign.stage_buffer, "Stage Buffer")
      map("n", "<leader>ghR", gitsign.reset_buffer, "Reset Buffer")

      map("n", "<leader>ghp", gitsign.preview_hunk_inline, "Preview Inline")
      map("n", "<leader>ghK", gitsign.preview_hunk, "Preview")

      map("n", "<leader>ghb", function() gitsign.blame_line { full = true } end, "Blame Line")
      map("n", "<leader>ghB", gitsign.blame, "Blame Buffer")

      map("n", "<leader>ghd", gitsign.diffthis, "Diff")
      map("n", "<leader>ghD", function() gitsign.diffthis "~" end, "Diff ~")

      map({ "o", "x" }, "ah", "<cmd>Gitsigns select_hunk<CR>", "Hunk")
      map({ "o", "x" }, "ih", "<cmd>Gitsigns select_hunk<CR>", "Hunk")

      map("n", "]H", function() gitsign.nav_hunk "last" end, "Last Hunk")
      map("n", "[H", function() gitsign.nav_hunk "first" end, "First Hunk")
      map("n", "]h", function()
        if vim.wo.diff then
          vim.cmd.normal { "]c", bang = true }
        else
          gitsign.nav_hunk "next"
        end
      end, "Next Hunk")
      map("n", "[h", function()
        if vim.wo.diff then
          vim.cmd.normal { "[c", bang = true }
        else
          gitsign.nav_hunk "prev"
        end
      end, "Prev Hunk")
    end,
  },
}
