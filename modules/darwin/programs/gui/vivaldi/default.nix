{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.vivaldi;
in
{
  options.${namespace}.programs.gui.vivaldi = {
    enable = mkEnableOption "Whether to enable Vivaldi browser.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "vivaldi"
      ];
    };
  };
}
