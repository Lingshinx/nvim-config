local cache = {}

---@type table<string,snacks.picker.Config|fun(snacks.picker.Config):snacks.picker.Config>
local M = {}

function M.filetypes(opts)
  if not cache.filetypes then
    local config = require "config.lsp"
    cache.filetypes = vim.tbl_map(function(filetype)
      local lang = config.get[filetype]
      local ret = {
        treesitter = not vim.tbl_isempty(lang and lang.treesitter or {}),
        text = filetype,
      }
      if lang then
        ret.formatter = lang.formatter and lang.formatter[1]
        ret.lsp = lang.lsp and lang:get_lspnames()[1]
      end
      return ret
    end, vim.fn.getcompletion("", "filetype"))
    local fn = require "config.lsp.fn"
    fn.foreach_lang(function(name, mod)
      local names = fn.get_names(mod)
      -- comment
      if false then
      end
    end)
  end
  local filetypes = cache.filetypes
  return vim.tbl_extend("force", {
    title = "Filetypes",
    layout = "vscode",
    sort_lastused = true,
    sort = { fields = { "treesitter", "lsp", "formatter" } },
    matcher = {
      sort_empty = true,
    },
    ---@param picker snacks.Picker
    format = function(item, picker)
      local filetype = item.text
      local align = Snacks.picker.util.align
      local width = vim.api.nvim_win_get_width(picker.layout.wins.list.win) - 2
      local center_width = vim.api.nvim_strwidth(item.formatter or "")
      local side_width = (width - center_width) / 2
      local icon, highlight = Snacks.util.icon(filetype, "filetype", {
        fallback = picker.opts.icons.files,
      })
      return {
        { align(icon, 2), highlight },
        {
          align(filetype, math.floor(side_width) - 2, { truncate = true }),
          item.treesitter and "" or "SnacksPickerDimmed",
        },
        { align(item.formatter, center_width, { align = "center", truncate = true }), "LingshinPickerFtFormatter" },
        { align(item.lsp, math.ceil(side_width), { align = "right", truncate = true }), "LingshinPickerFtLsp" },
      }
    end,
    items = filetypes,
    confirm = function(picker, item)
      picker:close()
      vim.bo.filetype = item.text
    end,
  }, opts or {})
end

return M
