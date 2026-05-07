local file_name_of = {}

local function get_lsp_name(lsp)
  if type(lsp) == "string" then
    return lsp
  elseif type(lsp) == "table" then
    for k, v in pairs(lsp) do
      return type(k) == "number" and v or k
    end
  end
end

local function get_name(spec)
  local names = {}
  for _, lang in ipairs(spec) do
    if type(lang) == "string" then
      names[#names + 1] = lang
    else
      vim.list_extend(names, get_name(lang))
    end
  end
  return names
end

local files = vim.api.nvim_get_runtime_file("langs/*.lua", true)
for _, file in ipairs(files) do
  local name = vim.fn.fnamemodify(file, ":t:r")
  local config = dofile(file)
  if config then
    if not config[1] then config[1] = name end
    for _, name in ipairs(get_name(config)) do
      file_name_of[name] = file
    end
  end
end

local filetypes = vim
  .iter(vim.fn.getcompletion("", "filetype"))
  :map(function(filetype)
    local lang = require("load.langs").data[filetype]
    local file_name = file_name_of[filetype]
    local ret = {
      treesitter = not vim.tbl_isempty(lang and lang.treesitter or {}),
      text = filetype,
      file = file_name,
    }
    if lang then
      ret.formatter = lang.formatter and lang.formatter[1]
      ret.lsp = lang.lsp and get_lsp_name(lang.lsp)
    end
    return ret
  end)
  :totable()

---@type snacks.picker.Config

return {
  title = "File Types",
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
        "@constant",
      },
      { align(item.lsp, math.ceil(side_width), { align = "right", truncate = true }), "Special" },
    }
  end,
  items = filetypes,
  confirm = function(picker, item)
    picker:close()
    vim.bo.filetype = item.text
  end,
}
