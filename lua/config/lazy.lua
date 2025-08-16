local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

require("lazy.core.handler.event").mappings.LazyFile = {
	id = "LazyFile",
	event = { "BufReadPost", "BufNewFile", "BufWritePre" },
}

require("lazy").setup({
	install = { colorscheme = { "tokyonight", "habamax" } },
	checker = { enabled = true, frequence = 24 * 60 * 60 },
	spec = {
		{ import = "plugins.component" },
		{ import = "plugins.ui" },
		{ import = "plugins.lsp" },
		{ import = "plugins.util" },
		{ import = "plugins.editor" },
		{ import = "plugins.lang" },
	},
	performance = {
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				"gzip",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})

vim.cmd.colorscheme("tokyonight")
