local diagnostic_icon = require("config.icons").diagnostics
local pick = require("utils.keymaps").pick
local reference_goto = require("utils.plugin.snacks").word_goto

local diagnostic_goto = function(count, severity)
  return function()
    vim.diagnostic.jump {
      count = count,
      severity = severity and vim.diagnostic.severity[severity] or nil,
    }
  end
end

local function diagnostic_preview()
  vim.diagnostic.open_float()
  vim.diagnostic.open_float()
end

local del = vim.keymap.del
del("n", "grn")
del("n", "gra")
del("n", "grr")
del("n", "gri")
del("n", "grt")

return {
  { "<leader>ca", vim.lsp.buf.code_action, desc = "Line Diagnostics" },
  { "[d", diagnostic_goto(-1), desc = "Diagnostic", icon = "" },
  { "]d", diagnostic_goto(1), desc = "Diagnostic", icon = "" },
  { "[e", diagnostic_goto(-1, "ERROR"), desc = "Error", icon = { icon = diagnostic_icon.Error, color = "red" } },
  { "]e", diagnostic_goto(1, "ERROR"), desc = "Error", icon = { icon = diagnostic_icon.Error, color = "red" } },
  { "[w", diagnostic_goto(-1, "WARN"), desc = "Warning", icon = { icon = diagnostic_icon.Warn, color = "yellow" } },
  { "]w", diagnostic_goto(1, "WARN"), desc = "Warning", icon = { icon = diagnostic_icon.Warn, color = "yellow" } },
  { "[[", reference_goto(-1), desc = "Reference", icon = { icon = "", color = "purple" } },
  { "]]", reference_goto(1), desc = "Reference", icon = { icon = "", color = "purple" } },
  { "<leader>xp", diagnostic_preview, desc = "Preview" },

  { "gD", pick "lsp_declarations", desc = "Goto Definition" },
  { "gd", pick "lsp_definitions", desc = "Goto Definition" },
  { "gr", pick "lsp_references", desc = "References" },
  { "gI", pick "lsp_implementations", desc = "Goto Implementation" },
  { "gt", pick "lsp_type_definitions", desc = "Goto T[y]pe Definition" },

  { "<leader>ss", pick "lsp_symbols", desc = "LSP Symbols" },
  { "<leader>sS", pick "lsp_workspace_symbols", desc = "LSP Workspace Symbols" },

  { "<leader>cl", pick "lsp_config", desc = "LSP" },
  { "<leader>ci", vim.show_pos, desc = "Inspect Pos" },
  { "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
  { "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", desc = "Add Comment Below" },
  { "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", desc = "Add Comment Above" },

  -- treesitter
  -- highlights under cursor

  { "<leader>cI", vim.treesitter.inspect_tree, desc = "Inspect Tree" },
  {
    "<Tab>",
    function() return vim.snippet.active { direction = 1 } and "<cmd>lua vim.snippet.jump(1)<cr>" or "<Tab>" end,
    mode = "s",
    expr = true,
    desc = "Jump Next",
  },

  -- snippet
  {
    "<S-Tab>",
    function() return vim.snippet.active { direction = -1 } and "<cmd>lua vim.snippet.jump(-1)<cr>" or "<S-Tab>" end,
    mode = { "i", "s" },
    expr = true,
    desc = "Jump Previous",
  },
}
-- Clear search and stop snippet on escape
