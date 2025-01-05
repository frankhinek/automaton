{
  config,
  inputs,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf getExe mkEnableOption;
  inherit (inputs) home-manager;

  cfg = config.${namespace}.programs.gui.discord;
in
{
  options.${namespace}.programs.gui.discord = {
    enable = mkEnableOption "Whether to enable Discord.";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        discord
      ];

      activation = mkIf pkgs.stdenv.isLinux {
        betterdiscordInstall = # bash
          home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            echo "Running betterdiscord install"
            ${getExe pkgs.betterdiscordctl} install || ${getExe pkgs.betterdiscordctl} reinstall || true
          '';
      };
    };
  };
}
