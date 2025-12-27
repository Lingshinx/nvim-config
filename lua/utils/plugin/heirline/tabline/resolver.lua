local api = vim.api

local M = {}

function M.bufname(buf) return api.nvim_buf_get_name(buf) end

function M.winname(win) return M.bufname(api.nvim_win_get_buf(win)) end

function M.tabname(tab) return M.winname(api.nvim_tabpage_get_win(tab)) end

return M
