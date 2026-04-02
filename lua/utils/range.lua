local M = {}

---@param node TSNode
---@return integer sr, integer sc, integer er, integer ec
function M.from_node(node)
  local srow, scol, erow, ecol = node:range()
  -- have: 0-indexed exclusive (unaligned)
  if ecol == 0 then
    local line = vim.api.nvim_buf_get_lines(0, erow - 1, erow, false)[1]
    erow = erow - 1
    ecol = math.max(#line, 1)
  end
  -- have: 0-indexed inclusive (aligned)
  return srow, scol, erow, ecol - 1
end

---@return integer sr, integer sc, integer er, integer ec
function M.from_visual()
  local start_pos = vim.fn.getpos "v"
  local end_pos = vim.fn.getpos "."
  local s_row, s_col, e_row, e_col = start_pos[2], start_pos[3], end_pos[2], end_pos[3]

  if s_row > e_row or (s_row == e_row and s_col > e_col) then return e_row - 1, e_col - 1, s_row - 1, s_col - 1 end

  return s_row - 1, s_col - 1, e_row - 1, e_col - 1
end

---@param n1 integer
---@param n2 integer
---@param n3 integer
---@param n4 integer
---@return integer sr, integer sc, integer er, integer ec
function M.to_cursor(n1, n2, n3, n4)
  -- 0-indexed inclusive -> 0-indexed exclusive
  return n1 + 1, n2, n3 + 1, n4
end

---@param n1 integer
---@param n2 integer
---@param n3 integer
---@param n4 integer
---@return integer sr, integer sc, integer er, integer ec
function M.to_ts_range(n1, n2, n3, n4)
  -- 0-indexed inclusive -> 0-indexed exclusive
  return n1, n2, n3, n4 + 1
end

--- Compare two positions (L and R) for sorting or positioning.
---
--- @param sr integer
--- @param sc integer
--- @param er integer
--- @param ec integer
--- @return integer
---   - Negative: L precedes R
---   - Zero:     L and R are Equal
---   - Positive: L succeeds R
function M.pos_comp(sr, sc, er, ec)
  if sr ~= er then return sr < er and -1 or 1 end
  if sc ~= ec then return sc < ec and -1 or 1 end
  return 0
end

--- -2 for L disjoint R
--- -1 for L overlapping R
--- 0 for L inside R
--- 1 for L equal R
--- 2 for L contain R
---@param sr_l integer
---@param sc_l integer
---@param er_l integer
---@param ec_l integer
---@param sr_r integer
---@param sc_r integer
---@param er_r integer
---@param ec_r integer
---@return integer
function M.renge_compare(sr_l, sc_l, er_l, ec_l, sr_r, sc_r, er_r, ec_r)
  if M.pos_comp(sr_l, sc_l, sr_r, sc_r) < 0 then
    if M.pos_comp(er_l, ec_l, sr_r, sc_r) < 0 then return -2 end
    if M.pos_comp(er_l, ec_l, er_r, ec_r) < 0 then return -1 end
    return 2
  end

  if M.pos_comp(sr_l, sc_l, sr_r, sc_r) == 0 then return 1 + M.pos_comp(er_l, ec_l, er_r, ec_r) end

  if M.pos_comp(sr_l, sc_l, er_r, ec_r) > 0 then return -2 end
  if M.pos_comp(er_l, ec_l, er_r, ec_r) > 0 then return -1 end
  return 0
end

---@param sr_l integer
---@param sc_l integer
---@param er_l integer
---@param ec_l integer
---@param sr_r integer
---@param sc_r integer
---@param er_r integer
---@param ec_r integer
---@return boolean
function M.equal(sr_l, sc_l, er_l, ec_l, sr_r, sc_r, er_r, ec_r)
  return sr_l == sr_r and sc_l == sc_r and er_l == er_r and ec_l == ec_r
end

---@param sr_l integer
---@param sc_l integer
---@param er_l integer
---@param ec_l integer
---@param sr_r integer
---@param sc_r integer
---@param er_r integer
---@param ec_r integer
---@return boolean
function M.contain(sr_l, sc_l, er_l, ec_l, sr_r, sc_r, er_r, ec_r)
  return M.pos_comp(sr_l, sc_l, sr_r, sc_r) < M.pos_comp(er_l, ec_l, er_r, ec_r)
end

---@param sr_l integer
---@param sc_l integer
---@param er_l integer
---@param ec_l integer
---@param sr_r integer
---@param sc_r integer
---@param er_r integer
---@param ec_r integer
---@return boolean
function M.inside(sr_l, sc_l, er_l, ec_l, sr_r, sc_r, er_r, ec_r)
  return M.pos_comp(sr_l, sc_l, sr_r, sc_r) > M.pos_comp(er_l, ec_l, er_r, ec_r)
end

return M
