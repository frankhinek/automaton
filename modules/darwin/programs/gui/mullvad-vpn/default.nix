{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.mullvad-vpn;
in
{
  options.${namespace}.programs.gui.mullvad-vpn = {
    enable = mkEnableOption "Whether to enable Mullvad VPN.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "mullvad-vpn"
      ];
    };
  };
}
