local zk = require "zk"
local command = require "zk.commands"

local function resolve_input(input)
  local sep = input:find(":", 1, true)
  return sep and { dir = vim.trim(input:sub(1, sep - 1)), title = vim.trim(input:sub(sep + 1)) }
    or { title = vim.trim(input) }
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
  local notebook = vim.env.ZK_NOTEBOOK_DIR
  if not notebook then notebook = vim.system({ "zk", "where" }, { text = true }):wait().stdout:sub(1, -2) end
  vim.env.ZK_NOTEBOOK_DIR = notebook
  local nargs = #opts.fargs
  if nargs == 0 then
    zk_new()
  else
    zk.new(resolve_input(opts.args))
  end
end, { nargs = "*" })

local function map(key, callback, desc, mode)
  return {
    "<leader>z" .. key,
    type(callback) == "string" and command.get(callback) or callback,
    desc = desc,
    mode = mode,
    remap = false,
    buffer = true,
  }
end

local function nmap(key, callback, desc) return map(key, callback, desc, "n") end

local function xmap(key, callback, desc) return map(key, callback, desc, "x") end

local keymaps = {
  { "<leader>z", group = "zettlekasten", icon = "" },
  nmap("n", zk_new, "New"),
  nmap("i", "ZkInsertLink", "Insert Link"),
  nmap("l", "ZkLinks", "Link"),
  nmap("L", "ZkBackLinks", "BackLinks"),
  nmap("s", "ZkMatch", "BackLinks"),
  xmap("i", "ZkInsertLinkAtSelection", "Insert Link"),
  xmap("n", "ZkNewFromTitleSelection", "New Title"),
  xmap("N", "ZkNewFromContentSelection", "New Content"),
}

local function set_keymaps()
  -- alias.where = "echo $ZK_NOTEBOOK_DIR"
  vim.system({ "zk", "where" }, { text = true }, function(result)
    if result.code ~= 0 then vim.notify(result.stderr, vim.log.ERROR) end
    vim.schedule(function()
      local notebook = result.stdout:sub(1, -2)
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
    zk.setup(opts)
    set_keymaps()
  end,
}
