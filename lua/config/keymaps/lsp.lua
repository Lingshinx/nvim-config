local map = vim.keymap.set
local diagnostic_icon = require("config.icons").diagnostics

local function picker(name) return Snacks.picker[name] end
local function diagnostic_goto(count, severity)
  return function()
    vim.diagnostic.jump {
      count = count,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    }
  end
end

require("which-key").add {
  { "<leader>cd", vim.diagnostic.open_float, desc = "Line Diagnostics" },
  { "]d", diagnostic_goto(1), desc = "Diagnostic", icon = "" },
  { "[d", diagnostic_goto(-1), desc = "Diagnostic", icon = "" },
  { "]e", diagnostic_goto(1, "ERROR"), desc = "Error", icon = { icon = diagnostic_icon.Error, color = "red" } },
  { "[e", diagnostic_goto(-1, "ERROR"), desc = "Error", icon = { icon = diagnostic_icon.Error, color = "red" } },
  { "]w", diagnostic_goto(1, "WARN"), desc = "Warning", icon = { icon = diagnostic_icon.Warn, color = "yellow" } },
  { "[w", diagnostic_goto(-1, "WARN"), desc = "Warning", icon = { icon = diagnostic_icon.Warn, color = "yellow" } },

  { "gD", picker "lsp_declarations", desc = "Goto Definition" },
  { "gd", picker "lsp_definitions", desc = "Goto Definition" },
  { "gr", picker "lsp_references", desc = "References" },
  { "gI", picker "lsp_implementations", desc = "Goto Implementation" },
  { "gt", picker "lsp_type_definitions", desc = "Goto T[y]pe Definition" },

  { "<leader>ss", picker "lsp_symbols", desc = "LSP Symbols" },
  { "<leader>sS", picker "lsp_workspace_symbols", desc = "LSP Workspace Symbols" },

  { "<leader>cl", picker "lsp_config", desc = "LSP" },
  { "<leader>ci", vim.show_pos, desc = "Inspect Pos" },
  { "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
  { "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", desc = "Add Comment Below" },
  { "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", desc = "Add Comment Above" },

  -- treesitter
  -- highlights under cursor
  {
    "<leader>cI",
    function()
      vim.treesitter.inspect_tree()
      vim.api.nvim_input "I"
    end,
    desc = "Inspect Tree",
  },
}

-- snippet
map(
  "s",
  "<Tab>",
  function() return vim.snippet.active { direction = 1 } and "<cmd>lua vim.snippet.jump(1)<cr>" or "<Tab>" end,
  { expr = true, desc = "Jump Next" }
)
map(
  { "i", "s" },
  "<S-Tab>",
  function() return vim.snippet.active { direction = -1 } and "<cmd>lua vim.snippet.jump(-1)<cr>" or "<S-Tab>" end,
  { expr = true, desc = "Jump Previous" }
)
-- Clear search and stop snippet on escape
map({ "i", "n", "s" }, "<esc>", function()
  vim.cmd "noh"
  if require("luasnip").expand_or_jumpable() then require("luasnip").unlink_current() end
  return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

-- commenting
