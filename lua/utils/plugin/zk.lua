local zk = require "zk"
local command = require "zk.commands"
local notebook

---@param input string
local function resolve_input(input)
  local sep = input:find(":", 1, true)
  if not sep then return { title = vim.trim(input) } end
  local tags = vim.trim(input:sub(sep + 1)):gsub(" ", ", ")
  local title = vim.trim(input:sub(1, sep - 1))
  return { title = title, extra = { tags = tags } }
end

local function zk_new()
  Snacks.input(
    {
      prompt = "Zk New",
      win = {
        relative = "editor",
        col = false, ---@diagnostic disable-line:assign-type-mismatch
        row = 2,
      },
    },
    ---@param input string
    function(input)
      if not input then return end
      zk.new(resolve_input(input))
    end
  )
end

vim.api.nvim_create_user_command("ZkAdd", function(opts)
  local nargs = #opts.fargs
  if nargs == 0 then
    zk_new()
  else
    zk.new(resolve_input(opts.args))
  end
end, { nargs = "*" })

local function map(mode, key, callback, desc)
  return {
    "<leader>z" .. key,
    type(callback) == "string" and command.get(callback) or callback,
    desc = desc,
    mode = mode,
    remap = false,
    buffer = true,
  }
end

local function nmap(...) return map("n", ...) end

local function xmap(...) return map("x", ...) end

local keymaps = {
  { "<leader>z", group = "zettlekasten", icon = "" },
  nmap("n", zk_new, "New"),
  nmap("z", "ZkNotes", "Notes"),
  nmap("t", "ZkTags", "Notes"),
  nmap("c", "ZkCd", "Cd"),
  nmap("i", "ZkInsertLink", "Insert Link"),
  nmap("l", "ZkLinks", "Link"),
  nmap("L", "ZkBackLinks", "BackLinks"),
  nmap("s", "ZkMatch", "BackLinks"),
  xmap("i", "ZkInsertLinkAtSelection", "Insert Link"),
}

local function set_notebooks()
  -- alias.where = "echo $ZK_NOTEBOOK_DIR"
  notebook = vim.env.ZK_NOTEBOOK_DIR
  if notebook then return end
  vim.system({ "zk", "where" }, { text = true }, function(result)
    if result.code ~= 0 then vim.notify(result.stderr, vim.log.ERROR) end
    vim.schedule(function()
      notebook = result.stdout:sub(1, -2) -- remove tailing '\n'
      vim.env.ZK_NOTEBOOK_DIR = notebook
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
        pattern = { notebook .. "/*.md" },
        callback = function() require("which-key").add(keymaps) end,
      })
    end)
  end)
end

return {
  setup = function(opts)
    set_notebooks()
    zk.setup(opts)
    vim.wait(1000, function() return notebook end)
  end,
}
