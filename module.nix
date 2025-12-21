{self}: {
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with types; let
  languages = with strings;
  with builtins;
    map
    (removeSuffix ".lua")
    (attrNames
      (filterAttrs
        (name: type: type == "regular" && strings.hasSuffix ".lua" name)
        (readDir ./langs)));
in {
  options.programs.neovim.lingshin-config = {
    enable = mkEnableOption "lingshin's nvim configuration";

    languages = mkOption {
      type = listOf (enum languages);
      default = [];
      description = ''
        list of supported languages names
      '';
    };

    extraLanguages = mkOption {
      type = listOf path;
      default = [];
      description = ''
        list of extra language files
      '';
    };
  };

  config = let
    nvim = config.programs.neovim;
    nvim-config = nvim.lingshin-config;
  in
    mkIf (nvim.enable && nvim-config.enable) {
      home.packages = with pkgs; [
        gnumake
        ripgrep
      ];

      xdg.configFile."nvim".source = let
        system = pkgs.stdenv.hostPlatform.system;
      in
        self.packages.${system}.default.override {
          inherit (nvim-config) languages extraLanguages;
        };

      programs.neovim = {
        plugins = [pkgs.vimPlugins.lazy-nvim];
      };
    };
}
