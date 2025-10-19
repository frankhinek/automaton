{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.warp;
in
{
  options.${namespace}.programs.gui.warp = {
    enable = mkEnableOption "Whether to enable Warp.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "warp"
      ];
    };
  };
}
