return {
  "kdl",
  "bash",
  { "json", lsp = "json-lsp", formatter = "prettier" },
  { "hyprlang", lsp = "hyprls", filetype = { pattern = ".*/hypr/.+%.conf" } },
  { "kitty", filetype = { pattern = ".*/kitty/.+%.conf" } },
}
