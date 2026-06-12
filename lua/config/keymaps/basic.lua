local fn = require "utils.keymaps"
local cmd, plug = fn.cmd, fn.config

local M
M = {
  { "<leader>K", cmd "norm! K", desc = "Keyword", icon = "" },
  { "<C-CR>", "<End><CR>", mode = "i" },
  { "<C-S-V>", '<C-r>"', mode = "!" },
  { "<S-Insert>", '<C-r>"', mode = "!" },
  { "<C-BS>", "<C-w>", mode = "!" },
  { "<C-Delete>", "<C-Right><C-w>", mode = "!" },

  -- Add undo break-points
  { ",", ",<c-g>u", mode = "i" },
  { ".", ".<c-g>u", mode = "i" },
  { ";", ";<c-g>u", mode = "i" },
  { "<C-S-V>", "<cmd>stopinsert<CR>pi", mode = "t", desc = "paste" },
  { "<S-Insert>", "<cmd>stopinsert<CR>pi", mode = "t", desc = "paste" },
  { "<esc><esc>", cmd "stopinsert", mode = "t", desc = "which_key_ignore" },

  -- better up/down
  { "j", "v:count == 0 ? 'gj' : 'j'", desc = "Down", expr = true, silent = true, mode = { "n", "x" } },
  { "k", "v:count == 0 ? 'gk' : 'k'", desc = "Up", expr = true, silent = true, mode = { "n", "x" } },

  -- Move Lines
  { "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", desc = "Move Down" },
  { "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" } },
  { "<A-j>", "<esc><cmd>m .+1<cr>==gi", mode = "i", desc = "Move Down" },
  { "<A-k>", "<esc><cmd>m .-2<cr>==gi", desc = "Move Up", mode = "i" },
  { "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", mode = "v", desc = "Move Down" },
  { "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", mode = "v", desc = "Move Up" },

  -- Clear search, diff update and redraw
  -- taken from runtime/lua/_editor.lua
  { "<leader>ur", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", desc = "Redraw/Update" },

  -- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
  { "n", "'Nn'[v:searchforward].'zv'", expr = true, desc = "Next Search Result" },
  { "N", "'nN'[v:searchforward].'zv'", expr = true, desc = "Prev Search Result" },
  { "n", "'Nn'[v:searchforward]", mode = { "x", "o" }, expr = true, desc = "Next Search Result" },
  { "N", "'nN'[v:searchforward]", mode = { "x", "o" }, expr = true, desc = "Prev Search Result" },

  -- save file
  { "<C-s>", "<cmd>w<cr>", mode = { "n", "x", "o", "i" }, desc = "Save File" },

  -- better indenting
  { "<", "<gv", mode = "v" },
  { ">", ">gv", mode = "v" },

  -- better duplicate
  { "yp", "<cmd>.t.<CR>" },

  { "<leader>n", plug "Notifications", desc = "Notifications" },
  { "<leader>qq", cmd "quitall", desc = "Quit All" },
  { [[<C-\>]], plug "OpenTerminal", desc = "ToggleTerm" },

  { "M", "mX", desc = "Mark" },
  { "gM", "`X", desc = "Goto Mark" },
  { "M", "`X", desc = "Goto Mark", mode = { "o", "x" } },
  { "<leader>um", cmd "delm!", desc = "Delete Marks" },

  { [[<C-\>]], plug "OpenTerminal", desc = "Toggle Term", mode = { "n", "t", "i", "x" } },

  {
    "<esc>",
    require("utils.keymap.escapes").escape,
    mode = { "n", "i", "s" },
    expr = true,
    desc = "Escape and Clear hlsearch",
  },
}
return M
