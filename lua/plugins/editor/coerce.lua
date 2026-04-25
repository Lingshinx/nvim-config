return {
  "gregorias/coop.nvim",
  {
    "gregorias/coerce.nvim",
    lazy = true,
    event = { "BufReadPre", "BufNewFile", "BufWritePre" },
    opts = {
      default_mode_keymap_prefixes = {
        normal_mode = "co",
        motion_mode = "sc",
        visual_mode = "sc",
      },
    },
  }
}
