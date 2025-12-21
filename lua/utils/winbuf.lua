local api = vim.api
return {
  is_full_size = function() return vim.o.columns > 135 end,
  norm_wins = function(tab)
    return vim
      .iter(api.nvim_tabpage_list_wins(tab))
      :filter(function(win) return api.nvim_get_option_value("buftype", { buf = api.nvim_win_get_buf(win) }) == "" end)
      :totable()
  end,
}
