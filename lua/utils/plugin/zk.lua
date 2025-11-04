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

-- alias.where = "echo $ZK_NOTEBOOK_DIR"
vim.system({ "zk", "where" }, { text = true }, function(result)
  Snacks.debug.log(result.stdout .. "/*.md")
  if result.code ~= 0 then vim.notify(result.stderr, vim.log.ERROR) end
  vim.schedule(function()
    local notebook = result.stdout:sub(1, -2)
    vim.env.ZK_NOTEBOOK_DIR = notebook
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
      pattern = { notebook .. "/*.md" },
      callback = function()
        require("which-key").add {
          { "<leader>z", group = "zettlekasten", icon = "" },
          { "<leader>zn", zk_new, desc = "New", remap = false, buffer = true },
          { "<leader>zi", command.get "ZkInsertLink", desc = "Insert Link", remap = false, buffer = true },
          { "<leader>zl", command.get "ZkLinks", desc = "Link", remap = false, buffer = true },
          { "<leader>zL", command.get "ZkBackLinks", desc = "BackLinks", remap = false, buffer = true },
          { "<leader>zs", command.get "ZkMatch", desc = "BackLinks", remap = false, buffer = true },
          {
            "<leader>zi",
            command.get "ZkInsertLinkAtSelection",
            desc = "Insert Link",
            remap = false,
            buffer = true,
            mode = "x",
          },
          {
            "<leader>zn",
            command.get "ZkNewFromTitleSelection",
            desc = "New Title",
            remap = false,
            buffer = true,
            mode = "x",
          },
          {
            "<leader>zN",
            command.get "ZkNewFromContentSelection",
            desc = "New Content",
            remap = false,
            buffer = true,
            mode = "x",
          },
        }
      end,
    })
  end)
end)
