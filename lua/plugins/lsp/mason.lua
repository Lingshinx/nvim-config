return {
	{
		"mason-org/mason.nvim",
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
	},

	{
		"mason-org/mason-lspconfig.nvim",
		lazy = true,
		opts = function()
			return {
				ensure_installed = require("config.lsp").mason,
			}
		end,
	},

	{
		"neovim/nvim-lspconfig",
		event = "LazyFile",
		dependencies = {
			"mason.nvim",
			"mason-org/mason-lspconfig.nvim",
		},
	},
}
