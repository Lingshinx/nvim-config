local map = require "utils.keymaps"
local plug, cmd = map.config, map.cmd
return {
  -- buffers
  { "<leader>bb", cmd "e #", desc = "Switch" },
  { "<leader>bd", plug "BufDelete", desc = "Delete" },
  { "<leader>bo", plug "BufDeleteOthers", desc = "Delete Others" },

  -- windows
  { "<leader>-", "<C-W>s", desc = "Split Below", icon = { icon = "", color = "blue" } },
  { "<leader>|", "<C-W>v", desc = "Split Right", icon = { icon = "", color = "blue" } },
  { "<leader>wd", "<C-W>c", desc = "Delete" },
  { "<leader>bD", cmd ":bd", desc = "Quit" },
  -- Move to window using <ctrl> arrow keys
  { "<C-h>", "<C-w>h", desc = "Go to Left" },
  { "<C-j>", "<C-w>j", desc = "Go to Lower" },
  { "<C-k>", "<C-w>k", desc = "Go to Upper" },
  { "<C-l>", "<C-w>l", desc = "Go to Right" },
  -- Resize window using <ctrl> arrow keys
  { "<C-S-k>", cmd "resize +2", desc = "Increase Height" },
  { "<C-S-j>", cmd "resize -2", desc = "Decrease Height" },
  { "<C-S-h>", cmd "vertical resize -2", desc = "Decrease Width" },
  { "<C-S-l>", cmd "vertical resize +2", desc = "Increase Width" },

  -- tabs
  { "<leader><tab>f", cmd "tabfirst", desc = "First" },
  { "<leader><tab>l", cmd "tablast", desc = "Last" },
  { "<leader><tab>o", cmd "tabonly", desc = "Delete Others" },
  { "<leader><tab>n", cmd "tabnew", desc = "New" },
  { "<leader><tab>d", cmd "tabclose", desc = "Delete" },
  { "<leader><tab>H", cmd "-tabm", desc = "Prev" },
  { "<leader><tab>L", cmd "+tabm", desc = "Next" },
  { "<S-l>", cmd "tabn", desc = "Tab Next" },
  { "<S-h>", cmd "tabp", desc = "Tab Prev" },

  { "<leader><tab>p", plug "TabPick", desc = "Pick" },
  { "<leader><tab>r", plug "TabRename", desc = "Rename" },
  { "<leader><tab>s", plug "TabSelect", desc = "Select" },
}
