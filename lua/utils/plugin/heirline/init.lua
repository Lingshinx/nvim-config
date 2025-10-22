local utils = require "heirline.utils"

local function colors()
  return {
    white = utils.get_highlight("Normal").fg,
    dark = utils.get_highlight("IncSearch").fg,
    bright_bg = utils.get_highlight("Folded").bg,
    bright_fg = utils.get_highlight("Folded").fg,
    red = utils.get_highlight("Substitute").bg,
    dark_red = utils.get_highlight("DiagnosticError").bg,
    green = utils.get_highlight("String").fg,
    blue = utils.get_highlight("Function").fg,
    gray = utils.get_highlight("NonText").fg,
    orange = utils.get_highlight("Constant").fg,
    yellow = utils.get_highlight("DiagnosticWarn").fg,
    purple = utils.get_highlight("Statement").fg,
    pink = utils.get_highlight("@keyword").fg,
    cyan = utils.get_highlight("Special").fg,
    aqua = utils.get_highlight("DiagnosticHint").fg,
    diag_warn = utils.get_highlight("DiagnosticWarn").fg,
    diag_error = utils.get_highlight("DiagnosticError").fg,
    diag_hint = utils.get_highlight("DiagnosticHint").fg,
    diag_info = utils.get_highlight("DiagnosticInfo").fg,
    git_removed = utils.get_highlight("diffRemoved").fg,
    git_added = utils.get_highlight("diffAdded").fg,
    git_changed = utils.get_highlight("diffChanged").fg,
  }
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function() utils.on_colorscheme(colors) end,
  group = vim.api.nvim_create_augroup("Heirline", { clear = true }),
})

return {
  statusline = require "utils.plugin.heirline.statusline",
  opts = {
    colors = colors(),
  },
}
