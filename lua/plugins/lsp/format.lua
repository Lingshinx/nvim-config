return {
	"stevearc/conform.nvim",
	event = "LazyFile",
	opts = {
		formatters_by_ft = require("config.langs").formattor,
	},
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format()
			end,
			mode = { "n", "v" },
			desc = "Format",
		},
	},
}
