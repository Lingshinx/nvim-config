return {
  "css",
  {
    "astro",
    lsp = {
      astro = {
        init_options = {
          typescript = {
            tsdk = "/usr/lib/node_modules/typescript/lib",
          },
        },
      },
    },
    pkgs = { "astro-language-server" },
  },
  formatter = "prettier",
  lsp = "tailwindcss",
  plugins = { "tronikelis/ts-autotag.nvim" },
}
