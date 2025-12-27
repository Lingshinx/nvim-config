local autocmd = vim.api.nvim_create_autocmd
local augroup = function(name) return vim.api.nvim_create_augroup("lingshin_" .. name, { clear = true }) end
local name = require "utils.plugin.heirline.tabline.name"

-- Auto Chdir
autocmd({ "BufEnter", "BufWinEnter" }, {
  desc = "Auto change dir to root",
  nested = true,
  callback = function()
    if vim.bo.buftype ~= "" then return end
    vim.fn.chdir(require("utils.root").get())
  end,
})

-- Auto Format
autocmd("BufWritePre", {
  desc = "Auto Format buffer",
  callback = function(args)
    if vim.g.autoformat and vim.b.autoformat ~= false then require("conform").format { bufnr = args.buf } end
  end,
})

-- Highlight on yank
autocmd("TextYankPost", {
  desc = "Highlight on yank",
  group = augroup "highlight_yank",
  callback = function() vim.highlight.on_yank() end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
autocmd("BufWritePre", {
  desc = "Auto Mkdir",
  callback = function(event)
    if event.match:match "^%w%w+:[\\/][\\/]" then return end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

autocmd("FileType", {
  desc = "Create keymap 'q'",
  pattern = require "config.autocmds.quit_filetypes",
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd "close"
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

-- resize splits if window got resized
autocmd("VimResized", {
  group = augroup "resize_splits",
  desc = "Resize splits on Window resized",
  callback = function()
    local tabpagenr = vim.api.nvim_tabpage_get_number(0)
    vim.cmd "tabdo wincmd ="
    vim.api.nvim_set_current_tabpage(tabpagenr)
  end,
})

-- load tabname after session file loaded
autocmd("SessionLoadPost", {
  desc = "Load tab names",
  callback = name.load,
})

autocmd("User", {
  desc = "Save tab names",
  pattern = "PersistenceSavePre",
  callback = name.save,
})
