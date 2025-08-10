if not vim.g.neovide then
  return
end

vim.g.neovide_input_time = true
vim.g.neovide_padding_top = 10
vim.g.neovide_padding_right = 0

vim.g.neovide_opacity = 0.8
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_input_ime = true
vim.g.neovide_underline_stroke_scale = 1.0

vim.g.neovide_cursor_unfocused_outline_width = 0
vim.g.neovide_cursor_unfocuesd_outline_width = 0
vim.g.neovide_cursor_animate_command_line = false
vim.g.neovide_cursor_smooth_blink = true

local function set_ime(args)
  if args.event:match("Enter$") then
    vim.g.neovide_input_ime = true
  else
    vim.g.neovide_input_ime = false
  end
end

local ime_input = vim.api.nvim_create_augroup("ime_input", { clear = true })

for _, event in ipairs({
  { "InsertEnter", "InsertLeave" },
  { "TermEnter", "TermLeave" },
  { "CmdlineEnter", "CmdlineLeave" },
}) do
  vim.api.nvim_create_autocmd(event, {
    group = ime_input,
    pattern = "*",
    callback = set_ime,
  })
end
