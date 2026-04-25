{ config, lib, namespace, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.conductor;
in {
  options.${namespace}.programs.gui.conductor = {
    enable = mkEnableOption "Whether to enable Conductor.";
  };

  config = mkIf cfg.enable { homebrew = { casks = [ "conductor" ]; }; };
}
