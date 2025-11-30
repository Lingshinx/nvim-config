{
  description = "Standalone Neovim config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = {
    flake-parts,
    nixpkgs,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} ({
        self,
        withSystem,
        flake-parts-lib,
        ...
      } @ top: {
        systems = nixpkgs.lib.platforms.all;
        flake.homeModules.default = flake-parts-lib.importApply ./module.nix {inherit self;};
        perSystem = {pkgs, ...}: {
          packages.default = pkgs.callPackage ./default.nix {};
        };
      });
}
