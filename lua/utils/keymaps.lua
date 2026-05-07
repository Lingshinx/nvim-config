---@alias utils.keymap.Mode "n"|"o"|"x"|"v"|"s"|"i"|"c"|"!"|"ia"|"ca"|"!a"|"!"

---@module "which-key"

---@class utils.keymap.Mapping: vim.keymap.set.Opts
---@field [1] string
---@field [2] string
---@field mode utils.keymap.Mode|utils.keymap.Mode[]
---@field icon? wk.Icon|string|fun():(wk.Icon|string)
---@field group? string

---@param mapping utils.keymap.Mapping
---@return vim.keymap.set.Opts
local function opts(mapping)
  return {
    desc = mapping.desc,
    remap = mapping.remap,
    noremap = mapping.noremap,
    expr = mapping.expr,
    buf = mapping.buf,
    silent = mapping.silent,
    unique = mapping.unique,
    replace_keycodes = mapping.replace_keycodes,
  }
end

---@param ft_mappings table<string, utils.keymap.Mapping[]>
local function add_ft(ft_mappings)
  for ft, mappings in pairs(ft_mappings) do
    vim.api.nvim_create_autocmd("FileType", {
      pattern = ft,
      callback = function()
        for _, mapping in ipairs(mappings) do
          local mode = mapping.mode
          if type(mode) == "table" then
            for _, m in ipairs(mode) do
              vim.api.nvim_buf_set_keymap(0, m, mapping[1], mapping[2], opts(mapping))
            end
          else
            vim.api.nvim_buf_set_keymap(0, mode, mapping[1], mapping[2], opts(mapping))
          end
        end
      end,
    })
  end
end

---@param mapping utils.keymap.Mapping
local function map(mapping) vim.keymap.set(mapping.mode or "n", mapping[1], mapping[2], opts(mapping)) end

return {
  map = map,
  ---@param mappings utils.keymap.Mapping[]
  add = function(mappings)
    for _, mapping in ipairs(mappings) do
      map(mapping)
    end
  end,
  add_ft = add_ft,

  plug = function(method) return "<Plug>(" .. method .. ")" end,
  config = function(method) return "<Plug>(Config" .. method .. ")" end,
  cmd = function(cmd) return "<Cmd>" .. cmd .. "<CR>" end,
  file = function(dir) return "<Cmd>PickFiles " .. dir .. "<CR>" end,
  pick = function(src) return "<Cmd>Pick " .. src .. "<CR>" end,
}
