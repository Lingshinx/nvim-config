return {
  "hedyhli/tree-sitter-cognate",
  ft = "cognate",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  enabled = vim.fn.has("nvim-0.9") == 1,
}
