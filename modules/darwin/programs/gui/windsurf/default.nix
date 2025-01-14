{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.windsurf;
in
{
  options.${namespace}.programs.gui.windsurf = {
    enable = mkEnableOption "Whether to enable Windsurf.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "windsurf"
      ];
    };
  };
}
