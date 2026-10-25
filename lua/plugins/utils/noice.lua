return {
  { "MunifTanjim/nui.nvim", load_before = "noice.nvim" },
  {
    "folke/noice.nvim",
    event = "DeferredUIEnter",
    opts = {
      routes = {
        {
          filter = {
            event = "notify",
            find = "No information available",
          },
          opts = { skip = true },
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
    },
    after = function(spec)
      if vim.g.neovide then
        vim.defer_fn(function() require("noice").setup(spec.opts) end, 50)
      else
        require("noice").setup(spec.opts)
      end
    end,
  },
}
