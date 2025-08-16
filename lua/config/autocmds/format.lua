vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		if vim.g.autoformat and vim.b.autoformat ~= false then
			require("conform").format({ bufnr = args.buf })
		end
	end,
})
