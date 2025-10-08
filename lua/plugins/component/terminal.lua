return {
  "akinsho/toggleterm.nvim",
  keys = { { [[<C-\>]], desc = "Toggle Term" } },
  opts = {
    open_mapping = [[<C-\>]],
    hide_numbers = true,
    start_in_insert = true,
    direction = "float",
    float_opts = {
      border = "rounded",
      width = function()
        local min = math.ceil(vim.o.columns * 0.8)
        return min > 130 and 130 or min
      end,
      title_pos = "center",
    },
    winbar = {
      enabled = true,
      name_formatter = function(term) return term.name end,
    },
  },
}
