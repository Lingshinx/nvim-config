return {
  formatter = "alejandra", -- Nix 社区推荐的格式化器
  lsp = {
    nixd = {
      -- nixd 的配置项
      settings = {
        nixd = {
          nixpkgs = {
            expr = "import <nixpkgs> {}", -- 可选: 指定 nixpkgs 表达式
          },
          options = {
            nixos = {
              expr = "(import <nixpkgs/nixos> {}).options",
            },
            home_manager = {
              expr = "(import <home-manager> {}).options",
            },
          },
        },
      },
    },
  },
}
