return {
  "tsx",
  "javascript",
  "typescript",
  { "javascriptreact", treesitter = false },
  { "typescriptreact", treesitter = false },
  formatter = "prettier",
  lsp = {
    vtsls = {
      filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
      },
      settings = {
        complete_function_calls = true,
        vtsls = {
          tsserver = {
            globalPlugins = {
              {
                name = "@astrojs/ts-plugin",
                enableForWorkspaceTypeScriptVersions = true,
                location = require("utils.plugin.mason").get_path(
                  "astro-language-server",
                  "node_modules/@astrojs/ts-plugin"
                ),
              },
            },
          },
          enableMoveToFileCodeAction = true,
          autoUseWorkspaceTsdk = true,
          experimental = {
            maxInlayHintLength = 30,
            completion = {
              enableServerSideFuzzyMatch = true,
            },
          },
        },
        typescript = {
          updateImportsOnFileMove = { enabled = "always" },
          suggest = {
            completeFunctionCalls = true,
          },
          inlayHints = {
            enumMemberValues = { enabled = true },
            functionLikeReturnTypes = { enabled = true },
            parameterNames = { enabled = "literals" },
            parameterTypes = { enabled = true },
            propertyDeclarationTypes = { enabled = true },
            variableTypes = { enabled = false },
          },
        },
      },
    },
  },
}
