{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.utm;
in
{
  options.${namespace}.programs.gui.utm = {
    enable = mkEnableOption "Whether to enable UTM.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "utm"
      ];
    };
  };
}
