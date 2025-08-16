return {
	filetypes = function()
		Snacks.picker.select(vim.fn.getcompletion("", "filetype"), {
			prompt = "filetype",
		}, function(filetype)
			if filetype then
				vim.bo.filetype = filetype
			end
		end)
	end,
}
