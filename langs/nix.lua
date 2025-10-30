return {
    formatter = "alejandra", -- Nix 社区推荐的格式化器
    lsp = {
        nixd = {
            -- nixd 的配置项
            settings = {
                nixd = {
                    formatting = {
                        command = { "alejandra" }, -- 让 LSP 调用 alejandra 格式化
                    },
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
