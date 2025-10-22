local M = {}

---@return {rows:integer, columns:integer, length:integer}
function M.visual_range()
  local start_pos = vim.fn.getpos "v"
  local end_pos = vim.fn.getpos "."
  local start_row, start_col, end_row, end_col = start_pos[2], start_pos[3], end_pos[2], end_pos[3]
  local abs = math.abs
  if start_row > end_row or (start_row == end_row and start_col > end_col) then
    start_row, start_col, end_row, end_col = end_row, end_col, start_row, start_col
  end

  local lines = vim.api.nvim_buf_get_text(0, start_row - 1, start_col - 1, end_row - 1, end_col, {})
  local length = 0

  for _, line in ipairs(lines) do
    length = length + #line
  end

  return {
    rows = end_row - start_row + 1,
    columns = abs(end_col - start_col + 1),
    length = length,
  }
end

return M
