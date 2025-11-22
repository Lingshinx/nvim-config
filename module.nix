{
  self,
}: {
  pkgs,
  config,
  lib,
  ...
}:

with lib;
with types;
let
  languages =
    with strings;
    map
      (removeSuffix ".lua")
      (attrNames
        (filterAttrs
          (name: type: type == "regular" && strings.hasSuffix ".lua" name)
          (readDir ./langs)));
in {
  options.programs.neovim.lingshin-config = {
    enable = mkEnableOption "lingshin's nvim configuration";

    dashboardCommand = mkOption {
      type = str;
      default = "echo hello world";
      description = ''
        the command which output with be shown in the dashboard
      '';
    };

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
    nvim-config = config.programs.neovim.lingshin-config;
  in mkIf nvim-config.enable {
    home.packages = with pkgs; [
      gnumake
      ripgrep
    ];

    xdg.configFile."nvim".source = let
        system = pkgs.stdenv.hostPlatform.system; 
      in self.packages.${system}.default.override {
        inherit (nvim-config) languages extraLanguages dashboardCommand;
      };

    programs.neovim = {
      plugins = [pkgs.vimPlugins.lazy-nvim];
    };
  };
}
