return {
  formatter = "typstyle",
  lsp = "tinymist",
  plugin = { "chomosuke/typst-preview.nvim", ft = "typst", opts = { dependencies_bin = { tinymist = "tinymist" } } },
}
