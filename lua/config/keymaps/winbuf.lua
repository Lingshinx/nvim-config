require("which-key").add {
  -- buffers
  { "<leader>bb", "<cmd>e #<cr>", desc = "Switch" },
  { "<leader>bd", Snacks.bufdelete.delete, desc = "Delete" },
  { "<leader>bo", Snacks.bufdelete.other, desc = "Delete Others" },

  -- windows
  { "<leader>-", "<C-W>s", desc = "Split Below", remap = true, icon = { icon = "", color = "blue" } },
  { "<leader>|", "<C-W>v", desc = "Split Right", remap = true, icon = { icon = "", color = "blue" } },
  { "<leader>wd", "<C-W>c", desc = "Delete", remap = true },
  { "<leader>bD", "<cmd>:bd<cr>", desc = "Quit" },
  -- Move to window using <ctrl> arrow keys
  { "<C-h>", "<C-w>h", desc = "Go to Left", remap = true },
  { "<C-j>", "<C-w>j", desc = "Go to Lower", remap = true },
  { "<C-k>", "<C-w>k", desc = "Go to Upper", remap = true },
  { "<C-l>", "<C-w>l", desc = "Go to Right", remap = true },
  -- Resize window using <ctrl> arrow keys
  { "<C-S-k>", "<cmd>resize +2<cr>", desc = "Increase Height" },
  { "<C-S-j>", "<cmd>resize -2<cr>", desc = "Decrease Height" },
  { "<C-S-h>", "<cmd>vertical resize -2<cr>", desc = "Decrease Width" },
  { "<C-S-l>", "<cmd>vertical resize +2<cr>", desc = "Increase Width" },

  -- tabs
  { "<leader><tab>f", "<cmd>tabfirst<cr>", desc = "First" },
  { "<leader><tab>l", "<cmd>tablast<cr>", desc = "Last" },
  { "<leader><tab>o", "<cmd>tabonly<cr>", desc = "Delete Others" },
  { "<leader><tab>n", "<cmd>tabnew<cr>", desc = "New" },
  { "<leader><tab>d", "<cmd>tabclose<cr>", desc = "Delete" },
}
