return {
  { "gregorias/coop.nvim" },
  {
    "gregorias/coerce.nvim",
    event = { "BufReadPre", "BufNewFile", "BufWritePre" },
    opts = {
      default_mode_keymap_prefixes = {
        normal_mode = "co",
        motion_mode = "sc",
        visual_mode = "sc",
      },
    },
  },
}
