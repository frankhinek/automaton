{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.gui.brave;
in
{
  options.${namespace}.programs.gui.brave = {
    enable = mkEnableOption "Whether to enable Brave.";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        nix-unstable.brave
      ];
    };
  };
}
