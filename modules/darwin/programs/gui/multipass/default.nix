{ config, lib, namespace, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.multipass;
in {
  options.${namespace}.programs.gui.multipass = {
    enable = mkEnableOption "Whether to enable Multipass.";
  };

  config = mkIf cfg.enable { homebrew = { casks = [ "multipass" ]; }; };
}
