return {
  -- pest
  { "pest-parser/pest.vim" },
  -- cognate
  {
    "hedyhli/tree-sitter-cognate",
    lazy = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    enabled = vim.fn.has("nvim-0.9") == 1,
  },
  -- typst
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    version = "1.*",
    config = function()
      require("typst-preview").setup({})
    end,
  },

  { "dmix/elvish.vim" },
}
