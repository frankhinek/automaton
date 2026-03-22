{ config, lib, pkgs, namespace, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.cli.tools.devenv;
in {
  options.${namespace}.programs.cli.tools.devenv = {
    enable = mkBoolOpt false "Whether to enable devenv.";
  };

  config =
    mkIf cfg.enable { home = { packages = with pkgs; [ devenv_2_0_6 ]; }; };
}
