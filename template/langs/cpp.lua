return {
  formatter = "clang-format",
  plugin= { "p00f/clangd_extensions.nvim", ft = { "c", "cpp" } },
  lsp = "clangd",
}
