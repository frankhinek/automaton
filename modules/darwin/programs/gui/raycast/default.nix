{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.raycast;
in
{
  options.${namespace}.programs.gui.raycast = {
    enable = mkEnableOption "Whether to enable Raycast.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "raycast"
      ];
    };
  };
}
