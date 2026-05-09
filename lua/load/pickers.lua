vim.api.nvim_create_autocmd("User", {
  pattern = "DeferredUIEnter",
  callback = function ()
    local sources = require "snacks.picker.config.sources"
    sources.filetypes = require "config.pickers.filetypes"
    sources.tabpages = require "config.pickers.tabpages"
  end
})
