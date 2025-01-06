{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.elgato;
in
{
  options.${namespace}.programs.gui.elgato = {
    enable = mkEnableOption "Whether to enable Elgato apps.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "elgato-control-center"
        "elgato-stream-deck"
      ];
    };
  };
}
