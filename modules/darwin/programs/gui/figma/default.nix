{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.figma;
in
{
  options.${namespace}.programs.gui.figma = {
    enable = mkEnableOption "Whether to enable Figma.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "figma"
      ];
    };
  };
}
