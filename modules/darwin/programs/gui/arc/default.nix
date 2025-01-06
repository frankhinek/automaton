{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.arc;
in
{
  options.${namespace}.programs.gui.arc = {
    enable = mkEnableOption "Whether to enable Arc browser.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "arc"
      ];
    };
  };
}
