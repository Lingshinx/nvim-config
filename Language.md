# Language Configuration Example

Let's create some files as example

## C++

```
nvim
├── init.lua
├── lazy-lock.json
├── lua
│   ├── config
│   │   ├── langs
│   │   │   └── cpp.lua <- this
│   └── plugins/
└── README.md
```

```lua
-- lua/config/langs/cpp.lua
return {
  lsp = "clangd",
  formatter = "clang-format",
  plugins = { "p00f/clangd_extensions.nvim", lazy = true },
}
```

Restart nvim and edit a c++ source file.
You will notice that `clangd`, `clang-format` and `treesitter-cpp` start to be installed.

When no language nested inside, the file name will be taken as language name.
Treesitter will automatically installed by language name.

## dotfiles

```lua
-- lua/config/langs/dotfiles.lua
-- you can add @type annotation to get lua_ls completition
---@type Config.LangConfig
return {
  "kdl",
  "bash",
  { "json", lsp = "json-lsp", formatter = "prettier" },
  { "hyprlang", lsp = "hyprls" },
}
```

treesitter **kdl, bash, json and hyprlang** will be installed.
and prettier will be set as json's formatter.

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

prettier will be set as formatter for **tsx, javascript, typescript, javascriptreact, typescriptreact**.

treesitter **tsx, javascript, typescript** will be installed.

### Lua

below is the example about how to configurate **lua_ls** for lua

```lua
-- lua/langs/lua.lua
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
