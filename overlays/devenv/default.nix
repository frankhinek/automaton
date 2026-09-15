{ devenv, ... }:
_final: prev: {
  devenv_2_3_1 = devenv.packages.${prev.stdenv.hostPlatform.system}.devenv;
}
