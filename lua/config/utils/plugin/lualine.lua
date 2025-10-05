local config = {
  modified_hl = "MatchParen",
  filename_hl = "Bold",
  directory_hl = "",
  modified_icon = "",
  readonly_icon = " 󰌾 ",
  length = 3,
}

---@param component any
---@param text string
---@param hl_group string
---@return string
local function highlight(component, text, hl_group)
  if hl_group == "" then return text end

  component.hl_cache = component.hl_cache or {}
  if not component.hl_cache[hl_group] then
    local utils = require "lualine.utils.utils"

    local hl_groups = vim.tbl_filter(function(x) return x end, {
      utils.extract_highlight_colors(hl_group, "bold") and "bold",
      utils.extract_highlight_colors(hl_group, "italic") and "italic",
    })
    component.hl_cache[hl_group] = component:create_hl({
      fg = utils.extract_highlight_colors(hl_group, "fg"),
      gui = #hl_groups > 0 and table.concat(hl_groups, ",") or nil,
    }, "LV_" .. hl_group)
  end
  return component:format_hl(component.hl_cache[hl_group]) .. text .. component:get_default_hl()
end

return {
  pretty_path = function(component)
    local path = vim.fn.expand "%:p" --[[@as string]]
    if path == "" then return "" end

    local root = require("config.utils.root").get()
    if path:find(root, 1, true) == 1 then path = path:sub(#root + 2) end

    local parts = vim.split(path, "/")
    if #parts > config.length then
      for index = 2, #parts - 1 do
        parts[index] = parts[index]:sub(1, 1)
      end
    end

    local file_hl = vim.bo.modified and config.modified_hl or config.filename_hl
    local filename = highlight(component, parts[#parts], file_hl)
    parts[#parts] = nil

    local dir = ""
    if #parts > 1 then dir = highlight(component, table.concat(parts, "/") .. "/", config.directory_hl) end

    local readonly = vim.bo.readonly and config.readonly_icon or ""
    return dir .. filename .. readonly
  end,
}
