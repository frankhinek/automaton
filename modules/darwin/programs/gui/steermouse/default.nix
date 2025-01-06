{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.steermouse;
in
{
  options.${namespace}.programs.gui.steermouse = {
    enable = mkEnableOption "Whether to enable SteerMouse.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "steermouse"
      ];
    };
  };
}
