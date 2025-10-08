local M = {}
M.format_toggle = Snacks.toggle {
  name = "Auto Format (Buffer)",
  get = function() return vim.b.autoformat end,
  set = function(state) vim.b.autoformat = state end,
}

M.format_toggle_global = Snacks.toggle {
  name = "Auto Format",
  get = function() return vim.g.autoformat end,
  set = function(state) vim.g.autoformat = state end,
}
return M
