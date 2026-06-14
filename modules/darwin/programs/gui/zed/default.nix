{ config, lib, namespace, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.zed;
in {
  options.${namespace}.programs.gui.zed = {
    enable = mkEnableOption "Whether to enable Zed code editor.";
  };

  config = mkIf cfg.enable { homebrew = { casks = [ "zed" ]; }; };
}
