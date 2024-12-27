{ pkgs, config, lib, ... }:
let
  monolisa-typeface = pkgs.callPackage ./packages/monolisa.nix { };
in {
  home.packages = [
     monolisa-typeface
  ];

  fonts.fontconfig.enable = true; # required to autoload fonts from packages
}