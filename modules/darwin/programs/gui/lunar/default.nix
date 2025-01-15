{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.lunar;
in
{
  options.${namespace}.programs.gui.lunar = {
    enable = mkEnableOption "Whether to enable Lunar.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "lunar"
      ];
    };
  };
}
