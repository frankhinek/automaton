{ devenv, ... }:
_final: prev: {
  devenv_2_2_2 = devenv.packages.${prev.stdenv.hostPlatform.system}.devenv;
}
