{ devenv, ... }:
_final: prev: {
  devenv_2_4_0 = devenv.packages.${prev.stdenv.hostPlatform.system}.devenv;
}
