{
  self,
  lazy-nvim
}: {pkgs, ...}: let
in {
  home.packages = with pkgs; [
    gnumake
    ripgrep
  ];

  xdg.dataFile."nvim/lazy/lazy-nvim" = {
    recursive = ture;
    source = lazy-nvim;
  }
  xdg.configFile."nvim".source = self.packages.${pkgs.stdenv.hostPlatform.system}.default;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
}
