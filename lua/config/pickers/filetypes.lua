local cache = {}

---@type snacks.picker.Config|fun(snacks.picker.Config):snacks.picker.Config>
return function(opts)
  if not cache.filetypes then
    local config = require "config.language"
    local file_name_of = {}
    local lang_fn = require "utils.language.fn"
    require("utils.fs").load_each(vim.fn.stdpath "config", "config.langs", function(file_name, mod)
      local names = lang_fn.get_names(mod)
      if vim.tbl_isempty(names) then
        file_name_of[file_name] = file_name
      else
        for _, lang_name in ipairs(names) do
          file_name_of[lang_name] = file_name
        end
      end
    end)
    cache.filetypes = vim.tbl_map(function(filetype)
      local lang = config.get[filetype]
      local file_name = file_name_of[filetype]
      local ret = {
        treesitter = not vim.tbl_isempty(lang and lang.treesitter or {}),
        text = filetype,
        file = file_name and lang_fn.get_path(file_name),
      }
      if lang then
        ret.formatter = lang.formatter and lang.formatter[1]
        ret.lsp = lang.lsp and lang:get_lspnames()[1]
      end
      return ret
    end, vim.fn.getcompletion("", "filetype"))
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
        {
          align(item.formatter, center_width, { align = "center", truncate = true }),
          "LingshinPickerFtFormatter",
        },
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
