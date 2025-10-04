{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.wireguard;
in
{
  options.${namespace}.programs.gui.wireguard = {
    enable = mkEnableOption "Whether to enable WireGuard.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      masApps = {
        "WireGuard" = 1451685025;
      };
    };
  };
}
