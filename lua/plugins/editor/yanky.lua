return {
  "gbprod/yanky.nvim",
  opts = {
    highlight = { timer = 150 },
    textobj = {
      enabled = true,
    },
  },
  --stylua: ignore
	keys = {
    { "iy", function() require("yanky.textobj").last_put() end, mode =  { "o", "x" }, desc = "Yanky last paste" },
    { "ay", function() require("yanky.textobj").last_put() end, mode =  { "o", "x" }, desc = "Yanky last paste" },
		{ "<leader>p", "<cmd>YankyRingHistory<CR>", mode = { "n", "x" }, desc = "Yank History" },
		{ "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put Text After Cursor" },
		{ "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put Text Before Cursor" },
		{ "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put Text After Selection" },
		{ "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put Text Before Selection" },
		{ "[y", "<Plug>(YankyCycleForward)", desc = "Cycle Forward Through Yank History" },
		{ "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle Backward Through Yank History" },
		{ "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor Line" },
		{ "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor Line" },
		{ "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor Line" },
		{ "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor Line" },
		{ ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and Indent Right" },
		{ "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and Indent Left" },
		{ ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put Before and Indent Right" },
		{ "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put Before and Indent Left" },
		{ "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put After Applying a Filter" },
		{ "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put Before Applying a Filter" },
	},

  config = function(_, opts)
    require("yanky").setup(opts)
    vim.api.nvim_del_augroup_by_name "lingshin_highlight_yank"
  end,
}
