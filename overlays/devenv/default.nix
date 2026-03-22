{ devenv, ... }:
_final: prev: {
  devenv_2_0_6 = devenv.packages.${prev.stdenv.hostPlatform.system}.devenv;
}
