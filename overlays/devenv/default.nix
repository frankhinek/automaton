{ devenv, ... }:
_final: prev: {
  devenv_2_0_5 = devenv.packages.${prev.stdenv.hostPlatform.system}.devenv;
}
