local filetypes = {
  "html",
  "astro",
  "vue",
  "typescriptreact",
}

---@type config.language.Config
return {
  "html",
  "css",
  {
    "astro",
    lsp = "astro",
    pkgs = { "astro-language-server" },
  },
  formatter = "prettier",
  lsp = { "tailwindcss" },
  plugins = {
    {
      "windwp/nvim-ts-autotag",
      ft = filetypes,
      event = "LazyFile",
      opts = {},
    },
    {
      "razak17/tailwind-fold.nvim",
      enabled = false,
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      ft = filetypes,
      opts = {},
    },
  },
}
