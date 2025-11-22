{
  lib,
  stdenvNoCC,

  dashboardCommand ? null,
  languages ? [],
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
    langs = "$out/lua/config/langs/";
  in ''
    mkdir -p $out
    cp -r $src/* $out

    chmod u+w $out/lua/config/
    if test -n "${toString languages}"
    then
      mkdir -p ${langs}
      ln -s ../../langs/{${concatStringsSep "," languages}} ${langs}
    fi

    if test -n "${toString extraLanguages}"
    then
      mkdir -p ${langs}
      cp "${toString extraLanguages}" ${langs}
    fi

    if test -n "${toString dashboardCommand}"
    then
      chmod +w ${snacks}
      sed 's@cmd = \[\[.*\]\]@cmd = [[${toString dashboardCommand}]]@' ${snacks} > ${snacks}
    fi
    '';
}
