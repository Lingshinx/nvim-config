{
  description = "Standalone Neovim config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    lazy-nvim = {
      url = "github:folke/lazy.nvim/stable";
      flake = false;
    };
  };

  outputs = {
    flake-parts,
    nixpkgs,
    ...
  } @ inputs: flake-parts.lib.mkFlake {inherit inputs;}({
      self,
      withSystem,
      flake-parts-lib,
      lazy-nvim,
      ...
      } @ top: {
        systems = nixpkgs.lib.platforms.all;
        flake.homeModules.default = flake-parts-lib.importApply ./module.nix {inherit self lazy-nvim;};
        perSystem = {pkgs,...}:{
          packages.default = pkgs.callPackage ./default.nix {};
        };
      });
}
