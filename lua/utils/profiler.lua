local snacks = vim.fn.stdpath "data" .. "/lazy/snacks.nvim"
vim.opt.rtp:append(snacks)
require("snacks.profiler").startup {
  startup = {
    event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
    -- event = "UIEnter",
    -- event = "VeryLazy",
  },
}

vim.api.nvim_create_autocmd("UIEnter", {
  callback = function()
    Snacks.toggle.profiler():map "<leader>dpp"
    Snacks.toggle.profiler_highlights():map "<leader>dph"

    vim.keymap.set("n", "<leader>dps", Snacks.profiler.scratch, { desc = "Profiler Scratch Bufer" })
  end,
})
