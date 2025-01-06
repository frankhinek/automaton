{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.thunderbird;
in
{
  options.${namespace}.programs.gui.thunderbird = {
    enable = mkEnableOption "Whether to enable Thunderbird.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "thunderbird"
      ];
    };
  };
}
