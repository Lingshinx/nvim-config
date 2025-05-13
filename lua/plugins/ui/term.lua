return {
  "akinsho/toggleterm.nvim",
  opts = {
    open_mapping = [[<C-\>]],
    hide_numbers = true,
    start_in_insert = true,
    direction = "float",
    float_opts = {
      border = "rounded",
      width = 130,
      title_pos = "center",
    },
    winbar = {
      enable = true,
      name_formatter = function(term)
        return term.name
      end,
    },
  },
}
