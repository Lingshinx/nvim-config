return {
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		opts = {},
	},

	{
		"mvllow/modes.nvim",
		event = "VeryLazy",
		opts = {
			colors = {
				delete = "#f5c359",
				copy = "#86e1fc",
				insert = "#c3e88d",
				replace = "#ff757f",
				visual = "#c099ff",
			},
			line_opacity = 0.15,
		},
	},
}
