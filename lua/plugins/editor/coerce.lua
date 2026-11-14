return {
  { "gregorias/coop.nvim", load_before = "coerce.nvim" },
  {
    "gregorias/coerce.nvim",
    event = { "BufReadPre", "BufNewFile", "BufWritePre" },
    keys = {
      { "sc", "<Plug>(coerce-motion)", desc = "Coerce" },
      { "sc", "<Plug>(coerce-visual)", mode = "x", desc = "Coerce" },
    },
    opts = {},
  },
}
