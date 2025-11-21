{self}: {pkgs, ...}: let
in {
  home.packages = with pkgs; [
    gnumake
    ripgrep
  ];

  xdg.configFile."nvim".source = self.packages.${pkgs.stdenv.hostPlatform.system}.default;

  programs.neovim = {
    enable = true;
    defaultEditor = true;

    plugins = [pkgs.vinPlugins.lazy-nvim];
  };
}
