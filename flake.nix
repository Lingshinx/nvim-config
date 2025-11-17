{
  description = "Standalone Neovim config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: {
    module = {pkgs, ...}: {
      home.packages = with pkgs; [
        gnumake
        ripgrep
      ];

      xdg.configFile."nvim" = {
        source = "${self}";
        recursive = true;
      };

      programs.neovim = {
        enable = true;
        defaultEditor = true;

        plugins = [pkgs.vimPlugins.lazy-nvim];
      };
    };
  };
}
