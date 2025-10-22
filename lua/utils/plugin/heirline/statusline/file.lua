local TermName = {
  provider = function() return " " .. vim.api.nvim_buf_get_name(0):gsub(".*:", "") end,
  condition = function() return vim.bo.buftype == "terminal" end,
}

local WorkDir = {
  flexible = 1,
  { provider = function(self) return " " .. vim.fn.fnamemodify(self.filename, ":.:h") .. "/" end },
  {
    provider = function(self)
      return " " .. require("utils.fs").shorten_path(vim.fn.fnamemodify(self.filename, ":.:h")) .. "/"
    end,
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
  condition = function() return vim.bo.filetype == "help" end,
  provider = function() return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t") end,
}

local Default = {
  provider = "",
}

return {
  fallthrough = false,
  TermName,
  HelpName,
  File,
  Default,
}
