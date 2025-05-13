return {
  "rareitems/printer.nvim",
  config = function()
    require("printer").setup({
      keymap = "gp", -- Plugin doesn't have any keymaps by default
    })
  end,
}
