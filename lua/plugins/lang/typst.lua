return {
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "typst" } },
  },
}
