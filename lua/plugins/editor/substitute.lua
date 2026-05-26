return {
  "gbprod/substitute.nvim",
  event = { "BufReadPre", "BufNewFile", "BufWritePre" },
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
  after = function()
    local substitute = require "substitute"
    substitute.setup { on_substitute = require("yanky.integration").substitute() }
    require("utils.escapes").add(require("substitute.range").clear_match)

    local map = vim.keymap.set
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
