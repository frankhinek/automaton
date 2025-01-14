{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.superwhisper;
in
{
  options.${namespace}.programs.gui.superwhisper = {
    enable = mkEnableOption "Whether to enable Superwhisper.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "superwhisper"
      ];
    };
  };
}
