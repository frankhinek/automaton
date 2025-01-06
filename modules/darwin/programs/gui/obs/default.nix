{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.obs;
in
{
  options.${namespace}.programs.gui.obs = {
    enable = mkEnableOption "Whether to enable OBS.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "obs"
      ];
    };
  };
}
