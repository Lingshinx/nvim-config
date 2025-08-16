---@type Config.LangConfig
return {
	lua = {
		formattor = "stylua",
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
	},

	cpp = {
		lsp = "clangd",
	},
	rust = {
		lsp = "rust_analyzer",
	},
}
