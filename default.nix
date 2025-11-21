{
  lib,
  stdenvNoCC,

  dashboardCommand ? null,
  Languages ? [],
  extraLanguages ? [],
}: let
  inherit (stdenvNoCC) mkDerivation;
  inherit (lib) cleanSource concatStringsSep ;
  inherit (builtins) map;
in mkDerivation {
  pname = "lingshin-nvim-config";
  version = "0.4";
  src = cleanSource ./.;

  installPhase = let
    snacks = "$out/lua/plugins/ui/snacks.lua";
  in ''
    mkdir -p $out
    cp -r $src/* $out

    if test -n "${toString Languages}"
    then
      mkdir -p lua/config/langs/
      ln -s ../../langs/{${concatStringsSep "," Languages}} $out/lua/config/langs/
    fi

    if test -n "${toString extraLanguages}"
    then
      mkdir -p $out/lua/config/langs/
      cp "${toString extraLanguages}" $out/lua/config/langs/
    fi

    if test -n "${toString dashboardCommand}"
    then
      chmod u+w $out/lua/plugins/ui/snacks.lua
      cat $out/lua/plugins/ui/snacks.lua
      substituteInPlace $out/lua/plugins/ui/snacks.lua \
        --replace 'cmd = [[.*]]' 'cmd = [[${toString dashboardCommand}]]'
    fi
    '';
}
