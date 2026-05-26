# Language Configuration Example

Let's create some files as example

## C++

```
nvim
├── init.lua
├── lazy-lock.json
├── lua
│   ├── config
│   └── plugins
├── langs
│   └── cpp.lua <- this
└── README.md
```

```lua
-- lua/config/langs/cpp.lua
return {
  lsp = "clangd",
  formatter = "clang-format",
  plugin = { "p00f/clangd_extensions.nvim", ft = "cpp" },
}
```

Restart nvim and edit a c++ source file.
Run `:Install all`, you will notice that `clangd`, `clang-format` and `treesitter-cpp` start to be installed.

When no language nested inside, the file name will be taken as language name.
Treesitter will automatically installed by language name.

## dotfiles

```lua
-- lua/config/langs/dotfiles.lua
return {
  "kdl",
  "bash",
  { "json", lsp = "jsonls", formatter = "prettier", nix = "vscode-json-languageserver" },
  { "hyprlang", lsp = "hyprls", filetype = { pattern = ".*/hypr/.+%.conf" } },
  { "kitty", filetype = { pattern = ".*/kitty/.+%.conf" } },
}
```

Treesitter **kdl, bash, json and hyprlang** will be installed.
And prettier will be set as json's formatter.

Easy to understand, right?

## javascript

```lua
-- lua/config/langs/javascript.lua
return {
    "tsx",
    "javascript",
    "typescript",
    { "javascriptreact", treesitter = false },
    { "typescriptreact", treesitter = false },
    formatter = "prettier",
}
```

Prettier will be set as formatter for **tsx, javascript, typescript, javascriptreact, typescriptreact**.

Treesitter **tsx, javascript, typescript** will be installed.

## Kotlin

```lua
-- lua/config/langs/kotlin.lua
return {
  lsp = "kotlin_lsp",
  formatter = "ktlint",
  packages = "kotlin-lsp",
  options = {
    shiftwidth = 4,
  },
}
```

After `v0.3`, you can set filetype-specific options in language config files.

## Lua

Below is the example about how to configurate **lua_ls** for lua

```lua
-- lua/config/langs/lua.lua
return {
  formatter = "stylua",
  lsp = {
    lua_ls = {
      settings = {
        Lua = {
          workspace = {
            checkThirdParty = false,
          },
          codeLens = {
            enable = true,
          },
          completion = {
            callSnippet = "Replace",
          },
          doc = {
            privateName = { "^_" },
          },
          hint = {
            enable = true,
            setType = false,
            paramType = true,
            paramName = "Disable",
            semicolon = "Disable",
            arrayIndex = "Disable",
          },
        },
      },
    },
  },
}
```
