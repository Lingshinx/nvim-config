return {
  set_highlight = function(config)
    local function set_hl(hl_group, value) vim.api.nvim_set_hl(0, hl_group, value) end
    for hl_group, value in pairs(config.override or {}) do
      set_hl(hl_group, value)
    end
    for hl_group, value in pairs(config.lingshin or {}) do
      set_hl("Lingshin" .. hl_group, value)
    end
  end,
}
