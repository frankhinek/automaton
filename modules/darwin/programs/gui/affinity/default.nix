{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.affinity;
in
{
  options.${namespace}.programs.gui.affinity = {
    enable = mkEnableOption "Whether to enable Affinity design apps.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "affinity-photo"
      ];
    };
  };
}
