---@class utils.treesitter.Entry
---@field tick integer
---@field nodes TSNode[]

---@class utils.treesitter.Nodes
---@field private entries utils.treesitter.Entry[]

local Nodes = {}

Nodes.entries = {}

---@private
---@param buf integer
---@return TSNode[]
function Nodes.get(buf)
  -- clear nodes on change tick, calling any methods on invalid nodes causes
  -- neovim to hard crash
  local entry = Nodes.entries[buf]
  local tick = vim.api.nvim_buf_get_changedtick(buf)
  if not entry or entry.tick ~= tick then
    entry = { tick = tick, nodes = {} }
    Nodes.entries[buf] = entry
  end
  return entry.nodes
end

---@param buf integer
---@param node TSNode
function Nodes.push(buf, node)
  local nodes = Nodes.get(buf)
  nodes[#nodes + 1] = node
end

---@param buf integer
---@return TSNode?
function Nodes.pop(buf)
  local nodes = Nodes.get(buf)
  local last = nodes[#nodes]
  nodes[#nodes] = nil
  return last
end

---@param buf integer
---@return TSNode?
function Nodes.last(buf)
  local nodes = Nodes.get(buf)
  return nodes[#nodes]
end

---@param buf integer
function Nodes.clear(buf) Nodes.entries[buf] = nil end

return Nodes
