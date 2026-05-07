return {
  "brenoprata10/nvim-highlight-colors",
  event = { "BufReadPre", "BufNewFile", "BufWritePre" },
  main = "nvim-highlight-colors",
  opts = {
    render = "virtual",
    virtual_symbol_position = "eow",
    virtual_symbol = "",
    virtual_symbol_prefix = " ",
  },
}
