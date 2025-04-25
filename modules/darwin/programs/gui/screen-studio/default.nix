{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.screen-studio;
in
{
  options.${namespace}.programs.gui.screen-studio = {
    enable = mkEnableOption "Whether to enable Screen Studio.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "screen-studio"
      ];
    };
  };
}
