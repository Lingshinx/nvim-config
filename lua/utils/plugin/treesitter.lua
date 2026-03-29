local M = {}

local util = require "utils.edit"

---@param langs string[]
function M.ensure_installed(langs)
  local installed = {}
  for f in vim.fs.dir(require("nvim-treesitter.config").get_install_dir "parser") do
    installed[vim.fn.fnamemodify(f, ":r")] = true
  end
  local not_installed = vim.iter(langs):filter(function(lang) return not installed[lang] end):totable()
  require("nvim-treesitter").install(not_installed)
end

---@param node TSNode
function M.select_node(node)
  local start_row, start_column, end_row, end_column = node:range()
  if end_column == 0 then
    end_row = end_row - 1
    end_column = #vim.api.nvim_buf_get_lines(0, end_row, end_row + 1, false)[1]
  end
  require("utils.edit").select { start_row + 1, start_column, end_row + 1, end_column - 1 }
end

---@param range [integer, integer, integer, integer]
function M.find_parent_of_range(range)
  local node = vim.treesitter.get_node()
  if not node then return end
  local compared = util.renge_compare(range, { node:range() })
  while compared ~= 0 do
    local parent = node:parent()
    if not parent then return end
    compared = util.renge_compare(range, { parent:range() })
    node = parent
  end
  return node
end

---@param range [integer, integer, integer, integer]
function M.find_chile_of_range(range)
  local node = vim.treesitter.get_node()
  if not node then return end
  local compared = util.renge_compare(range, { node:range() })
  if compared == 0 then return end
  if compared == 1 then return node:named_child(0) end
  while true do
    local parent = node:parent()
    if not parent then return node:named_child(0) end
    compared = util.renge_compare(range, { parent:range() })
    if compared == 0 or compared == 1 then return node end
    node = parent
  end
end

function M.incremental_select()
  local mode = vim.fn.mode()

  if mode:sub(1) == "n" then
    local node = vim.treesitter.get_node()
    if node then M.select_node(node) end
    return
  end

  if mode ~= "v" then vim.cmd.normal { "v", bang = true } end

  local node = M.find_parent_of_range { util.visual_range() }

  if node then M.select_node(node) end
end

function M.decremental_select()
  local mode = vim.fn.mode()

  if mode:sub(1) == "n" then return end

  if mode ~= "v" then vim.cmd.normal { "v", bang = true } end

  local node = M.find_chile_of_range { util.visual_range() }

  Snacks.debug(node)

  if node then M.select_node(node) end
end

return M
