vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	desc = "Auto change dir to root",
	callback = function()
		if vim.bo.buftype ~= "" then
			return
		end
		vim.fn.chdir(require("config.utils.root").get())
	end,
})
