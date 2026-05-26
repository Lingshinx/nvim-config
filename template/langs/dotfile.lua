return {
  "kdl",
  "bash",
  { "json", lsp = "jsonls", formatter = "prettier", nix = "vscode-json-languageserver" },
  { "hyprlang", lsp = "hyprls", filetype = { pattern = ".*/hypr/.+%.conf" } },
  { "kitty", filetype = { pattern = ".*/kitty/.+%.conf" } },
}
