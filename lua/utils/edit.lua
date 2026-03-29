local M = {}

---@return integer, integer, integer, integer
function M.visual_range()
  local start_pos = vim.fn.getpos "v"
  local end_pos = vim.fn.getpos "."
  local start_row, start_col, end_row, end_col = start_pos[2], start_pos[3], end_pos[2], end_pos[3]

  if start_row > end_row or (start_row == end_row and start_col > end_col) then
    start_row, start_col, end_row, end_col = end_row, end_col, start_row, start_col
  end

  return start_row - 1, start_col - 1, end_row - 1, end_col
end

--- Compare two positions (L and R) for sorting or positioning.
---
--- @param row_l integer
--- @param col_l integer
--- @param row_r integer
--- @param col_r integer
--- @return integer
---   - Negative: L precedes R
---   - Zero:     L and R are Equal
---   - Positive: L succeeds R
function M.position_compare(row_l, col_l, row_r, col_r)
  if row_l ~= row_r then return row_l < row_r and -1 or 1 end
  if col_l ~= col_r then return col_l < col_r and -1 or 1 end
  return 0
end

--- -2 for L disjoint R
--- -1 for L overlapping R
--- 0 for L inside R
--- 1 for L equal R
--- 2 for L contain R
---@param range_l [integer, integer, integer, integer]
---@param range_r [integer, integer, integer, integer]
---@return integer
function M.renge_compare(range_l, range_r)
  if M.position_compare(range_l[1], range_l[2], range_r[1], range_r[2]) < 0 then
    if M.position_compare(range_l[3], range_l[4], range_r[1], range_r[2]) < 0 then return -2 end
    if M.position_compare(range_l[3], range_l[4], range_r[3], range_r[4]) < 0 then return -1 end
    return 2
  end

  if M.position_compare(range_l[1], range_l[2], range_r[1], range_r[2]) == 0 then
    return 1 + M.position_compare(range_l[3], range_l[4], range_r[3], range_r[4])
  end

  if M.position_compare(range_l[1], range_l[2], range_r[3], range_r[4]) > 0 then return -2 end
  if M.position_compare(range_l[3], range_l[4], range_r[3], range_r[4]) > 0 then return -1 end
  return 0
end

---@param range [integer, integer, integer, integer]
function M.select(range)
  if vim.fn.mode() == "v" then
    vim.api.nvim_win_set_cursor(0, { range[3], range[4] })
    vim.cmd.normal { "o", bang = true }
    vim.api.nvim_win_set_cursor(0, { range[1], range[2] })
  else
    vim.api.nvim_win_set_cursor(0, { range[3], range[4] })
    vim.cmd.normal { "v", bang = true }
    vim.api.nvim_win_set_cursor(0, { range[1], range[2] })
  end
end

return M
