local toggle = Snacks.toggle

toggle.new {
  id = "format",
  name = "Auto Format (Buffer)",
  get = function() return vim.b.autoformat end,
  set = function(state) vim.b.autoformat = state end,
}

toggle.new {
  id = "format_global",
  name = "Auto Format",
  get = function() return vim.g.autoformat end,
  set = function(state) vim.g.autoformat = state end,
}

return toggle.toggles
