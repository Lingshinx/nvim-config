return {
  formatter = "clang-format",
  plugins = { "p00f/clangd_extensions.nvim", ft = { "c", "cpp" } },
  lsp = "clangd",
}
