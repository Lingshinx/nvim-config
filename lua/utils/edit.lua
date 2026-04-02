local M = {}

---@param sr integer
---@param sc integer
---@param er integer
---@param ec integer
function M.select(sr, sc, er, ec)
  if vim.fn.mode() == "v" then
    vim.api.nvim_win_set_cursor(0, { er, ec })
    vim.cmd.normal { "o", bang = true }
    vim.api.nvim_win_set_cursor(0, { sr, sc })
  else
    vim.api.nvim_win_set_cursor(0, { er, ec })
    vim.cmd.normal { "v", bang = true }
    vim.api.nvim_win_set_cursor(0, { sr, sc })
  end
end

return M
