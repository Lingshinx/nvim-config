local fs = require "utils.fs"

local TermName = {
  provider = function() return " " .. vim.api.nvim_buf_get_name(0):gsub("^.*:", ""):gsub(";#toggleterm#[0-9]$", "") end,
  hl = { fg = "green", bold = true },
  condition = function() return vim.bo.buftype == "terminal" end,
}

local WorkDir = {
  flexible = 1,
  {
    provider = function(self)
      local dir = vim.fn.fnamemodify(self.filename, ":.:h")
      return dir == "." and " " or " " .. dir .. "/"
    end,
  },
  {
    provider = function(self) return " " .. fs.shorten_path(vim.fn.fnamemodify(self.filename, ":.:h")) .. "/" end,
  },
  { provider = " " },
}

local FileName = {
  flexible = 10,
  { provider = function(self) return vim.fn.fnamemodify(self.filename, ":t") end },
  { provider = "" },
  hl = function() return { fg = vim.bo.modified and "orange" or "white", bold = true } end,
}

local FileIcon = {
  init = function(self)
    self.icon, self.icon_hl = Snacks.util.icon(self.filename)
  end,
  provider = function(self) return self.icon end,
  hl = function(self) return self.icon_hl end,
}

local FileFlags = {
  flexible = 3,
  condition = function() return not vim.bo.modifiable or vim.bo.readonly end,
  { provider = " " },
  { provider = "" },
  hl = { fg = "orange" },
}

local File = {
  condition = function() return vim.bo.buftype == "" end,
  init = function(self) self.filename = vim.api.nvim_buf_get_name(0) end,
  update = { "BufEnter", "TextChanged", "VimResized" },
  FileIcon,
  WorkDir,
  FileName,
  FileFlags,
}

local HelpName = {
  { provider = "󱛉 ", hl = { fg = "green" } },
  {
    provider = function() return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t:r") end,
    hl = { bold = true, fg = "white" },
  },
  condition = function() return vim.bo.filetype == "help" end,
}

local OilName = {
  condition = function() return vim.bo.buftype == "acwrite" and vim.bo.filetype == "oil" end,
  { provider = " ", hl = { fg = "yellow" } },
  {
    provider = function() return fs.tilde(vim.api.nvim_buf_get_name(0):sub(7)) end,
    hl = { bold = true, fg = "white" },
  },
}

local Default = {
  provider = "",
}

return {
  fallthrough = false,
  TermName,
  HelpName,
  File,
  OilName,
  Default,
}
