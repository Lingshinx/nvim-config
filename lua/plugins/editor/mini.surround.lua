return {
	"echasnovski/mini.surround",
	keys = {
		{ "gsa", desc = "Add" },
		{ "gsd", desc = "Delete" },
		{ "gsf", desc = "Find right" },
		{ "gsF", desc = "Find left" },
		{ "gsh", desc = "Highlight" },
		{ "gsr", desc = "Replace" },
		{ "gsn", desc = "Update Number of within lines" },
	},
	opts = {
		mappings = {
			add = "gsa",
			delete = "gsd",
			find = "gsf",
			find_left = "gsF",
			highlight = "gsh",
			replace = "gsr",
			update_n_lines = "gsn",

			suffix_last = "[",
			suffix_next = "]",
		},
	},
}
