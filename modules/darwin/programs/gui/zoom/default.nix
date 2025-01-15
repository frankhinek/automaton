{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.zoom;
in
{
  options.${namespace}.programs.gui.zoom = {
    enable = mkEnableOption "Whether to enable Zoom.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "zoom"
      ];
    };
  };
}
