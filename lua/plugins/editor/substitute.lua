return {
  "gbprod/substitute.nvim",
  event = "VeryLazy",
  keys = {
    { "ds", desc = "Substitute" },
    { "dss", desc = "Substitute Line" },
    { "dS", desc = "Substitute Eol" },
    { "ss", desc = "Substitute", mode = "x" },
    { "#", desc = "Substitute", mode = { "n", "x" } },
    { "g#", desc = "Substitute Command" },
    { "dx", desc = "Exchange" },
    { "dxx", desc = "Exchange" },
    { "x", desc = "Exchange", mode = "x" },
  },
  config = function()
    require("substitute").setup {
      on_substitute = require("yanky.integration").substitute(),
    }

    local map = vim.keymap.set
    local substitute = require "substitute"
    map("n", "ds", substitute.operator, { noremap = true })
    map("n", "dss", substitute.line, { noremap = true })
    map("n", "dS", substitute.eol, { noremap = true })
    map("x", "s", substitute.visual, { noremap = true })

    local range = require "substitute.range"
    map("n", "g#", range.operator, { noremap = true })
    map("x", "#", range.visual, { noremap = true })
    map("n", "#", range.word, { noremap = true })

    local exchange = require "substitute.exchange"
    map("n", "dx", exchange.operator, { noremap = true })
    map("n", "dxx", exchange.line, { noremap = true })
    map("x", "x", exchange.visual, { noremap = true })
  end,
}
