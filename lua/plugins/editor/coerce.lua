return {
  "gregorias/coerce.nvim",
  dependencies = { "gregorias/coop.nvim" },
  event = "LazyFile",
  opts = {
    default_mode_keymap_prefixes = {
      normal_mode = "co",
      motion_mode = "gsc",
      visual_mode = "gsc",
    },
  },
}
