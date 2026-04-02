local range = require "utils.range"
local Nodes = require "utils.plugin.treesitter.nodes"
local Deque = require "utils.deque"

local from_node = range.from_node
local from_visual = range.from_visual
local to_cursor = range.to_cursor
local to_ts_range = range.to_ts_range

---@param langs string[]
local function ensure_installed(langs)
  local installed = {}
  for f in vim.fs.dir(require("nvim-treesitter.config").get_install_dir "parser") do
    installed[vim.fn.fnamemodify(f, ":r")] = true
  end
  local not_installed = vim.iter(langs):filter(function(lang) return not installed[lang] end):totable()
  require("nvim-treesitter").install(not_installed)
end

local function select(node) require("utils.edit").select(to_cursor(from_node(node))) end

local function init_select(buf)
  local node = vim.treesitter.get_node()
  if not node then return end
  select(node)
  Nodes.clear(buf)
  Nodes.push(buf, node)
end

---@param buf integer
---@param ... integer
local function incremented_range(buf, ...)
  local parser = vim.treesitter.get_parser()
  if not parser then return end

  local node ---@type TSNode?
  local sr, sc, er, ec = ...

  local last = Nodes.last(buf)
  if not last or range.inside(sr, sc, er, ec, from_node(last)) then
    Nodes.clear(buf)
    node = parser:named_node_for_range { to_ts_range(...) }
  else
    node = last
  end

  while node and not range.inside(sr, sc, er, ec, from_node(node)) do
    node = node:parent()
  end

  if node then Nodes.push(buf, node) end
  return node
end

local function incremental_select()
  local mode = vim.fn.mode()
  local buf = vim.api.nvim_get_current_buf()

  if mode:sub(1) == "n" then
    init_select(buf)
    return
  end

  if mode ~= "v" then vim.cmd.normal { "v", bang = true } end

  local node = incremented_range(buf, from_visual())

  if node then select(node) end
end

---@param parser vim.treesitter.LanguageTree
---@param ... integer
local function get_child_inside(parser, ...)
  local node = parser:named_node_for_range { ... }
  local sr, sc, er, ec = ...
  local queue = Deque.new { node } ---@type utils.Deque<TSNode>
  local front = queue:pop_front() ---@type TSNode?
  while front do
    local comp_result = range.renge_compare(sr, sc, er, ec, from_node(front))
    -- front is inside of range
    if comp_result == 2 then return front end
    -- front contains or is equal to range
    if comp_result == 1 or comp_result == 0 then
      queue:clear()
      queue:concat(front:named_children())
    elseif comp_result == -1 then
      queue:concat(front:named_children())
    end

    front = queue:pop_front()
  end
end

---@param buf integer
---@param ... integer
local function decremented_range(buf, ...)
  local parser = vim.treesitter.get_parser()
  if not parser then return end

  local sr, sc, er, ec = ...

  local last = Nodes.last(buf)

  if last then
    local comp_result = range.renge_compare(sr, sc, er, ec, from_node(last))
    if comp_result == 1 then
      Nodes.pop(buf)
      local node = Nodes.last(buf)
      if node then return node end
    elseif comp_result == 2 then
      local node = last
      local parent = last:parent()
      while parent and range.contain(sr, sc, er, ec, from_node(parent)) do
        local sr_p, sc_p, er_p, ec_p = parent:range()
        if range.contain(sr_p, sc_p, er_p, ec_p, from_node(node)) then Nodes.push(buf, parent) end
        node = parent
        parent = parent:parent()
      end
      return node
    end

    Nodes.clear(buf)
  end

  return get_child_inside(parser, ...)
end

local function decremental_select()
  local mode = vim.fn.mode()
  local buf = vim.api.nvim_get_current_buf()

  if mode:sub(1) == "n" then return end

  if mode ~= "v" then vim.cmd.normal { "v", bang = true } end

  local node = decremented_range(buf, from_visual())

  if node then select(node) end
end

---@param get_sibling fun(node:TSNode):TSNode?
local function sibling_select(get_sibling)
  local buf = vim.api.nvim_get_current_buf()
  local sr, sc, er, ec = from_visual()
  local last = Nodes.last(buf)
  local node

  if last and range.equal(sr, sc, er, ec, from_node(last)) then
    node = last
  else
    local parser = vim.treesitter.get_parser()
    if not parser then return end
    node = parser:named_node_for_range { sr, sc, er, ec }
    if not node then return end
  end

  local parent = node:parent() ---@type TSNode?
  while parent and parent:named_child_count() <= 1 do
    node = parent
    parent = parent:parent()
  end

  local sibling = get_sibling(node)

  Nodes.clear(buf)
  if sibling then
    select(sibling)
    Nodes.push(buf, sibling)
  end
end

local function prev_select()
  sibling_select(function(node) return node:prev_named_sibling() end)
end

local function next_select()
  sibling_select(function(node) return node:next_named_sibling() end)
end

local function first_select()
  sibling_select(function(node)
    local parent = node:parent()
    if not parent then return end
    return parent:named_children()[1]
  end)
end

local function last_select()
  sibling_select(function(node)
    local parent = node:parent()
    if not parent then return end
    local children = parent:named_children()
    return children[#children]
  end)
end

return {
  incremental_select = incremental_select,
  decremental_select = decremental_select,

  next_select = next_select,
  prev_select = prev_select,
  first_select = first_select,
  last_select = last_select,

  ensure_installed = ensure_installed,
}
