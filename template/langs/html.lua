return {
  "css",
  "html",
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
    package = "astro-language-server",
  },
  formatter = "prettier",
  lsp = "tailwindcss",
  plugin = { "tronikelis/ts-autotag.nvim", ft = { "astro", "html" } },
  package = "tailwindcss-language-server",
}
