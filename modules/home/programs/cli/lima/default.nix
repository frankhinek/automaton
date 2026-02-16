{ config, lib, namespace, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.cli.lima;
in {
  options.${namespace}.programs.cli.lima = {
    enable = mkEnableOption "Whether to enable Lima.";
  };

  config = mkIf cfg.enable {
    home = { packages = with pkgs; [ nix-unstable.lima ]; };
  };
}
