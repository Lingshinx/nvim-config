Snacks.toggle.option("spell", { name = "Spelling" }):map "<leader>us"
Snacks.toggle.option("wrap", { name = "Wrap" }):map "<leader>uw"
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map "<leader>uL"
Snacks.toggle.diagnostics():map "<leader>ud"
Snacks.toggle.line_number():map "<leader>ul"
Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel, name = "Conceal Level" }):map "<leader>uc"
Snacks.toggle.option("showtabline", { off = 0, on = vim.o.showtabline, name = "Tabline" }):map "<leader>uA"
Snacks.toggle.treesitter():map "<leader>uT"
Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map "<leader>ub"
Snacks.toggle.dim():map "<leader>uD"
Snacks.toggle.animate():map "<leader>ua"
Snacks.toggle.indent():map "<leader>ug"
Snacks.toggle.scroll():map "<leader>uS"
Snacks.toggle.zoom():map("<leader>wm"):map "<leader>uZ"
Snacks.toggle.zen():map "<leader>uz"
Snacks.toggle.inlay_hints():map "<leader>uh"

Snacks.toggle.new {
  id = "format",
  name = "Auto Format (Buffer)",
  get = function() return vim.b.autoformat end,
  set = function(state) vim.b.autoformat = state end,
}:map "<leader>uf"

Snacks.toggle.new({
  id = "format_global",
  name = "Auto Format",
  get = function() return vim.g.autoformat end,
  set = function(state) vim.g.autoformat = state end,
}):map "<leader>uF"

Snacks.toggle.new(require("utils.cliapend")):map "<leader>uy"
