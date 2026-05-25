{ devenv, ... }:
_final: prev: {
  devenv_2_1_2 = devenv.packages.${prev.stdenv.hostPlatform.system}.devenv;
}
