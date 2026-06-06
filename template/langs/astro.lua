return {
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
  formatter = "prettier",
  package = "astro-language-server",
}
