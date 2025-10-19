{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.zen;
in
{
  options.${namespace}.programs.gui.zen = {
    enable = mkEnableOption "Whether to enable Zen browser.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "zen"
      ];
    };
  };
}
