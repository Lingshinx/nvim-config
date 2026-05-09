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
  },
}
