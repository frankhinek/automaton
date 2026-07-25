{ config, lib, pkgs, namespace, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.cli.nodejs;
in {
  options.${namespace}.programs.cli.nodejs = {
    enable = mkEnableOption "Whether to enable Node.js.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ nix-unstable.nodejs_24 ];
  };
}
