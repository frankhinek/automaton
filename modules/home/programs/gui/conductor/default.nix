{ config, lib, namespace, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.gui.conductor;
in {
  options.${namespace}.programs.gui.conductor = {
    enable = mkEnableOption "Whether to enable Conductor.";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [ pkgs.${namespace}.conductor ];

      file."Applications/Conductor.app".source =
        "${pkgs.${namespace}.conductor}/Applications/Conductor.app";
    };
  };
}
