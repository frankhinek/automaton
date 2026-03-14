{ config, lib, namespace, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.gui.codex-app;
in {
  options.${namespace}.programs.gui.codex-app = {
    enable = mkEnableOption "Whether to enable Codex app.";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [ pkgs.${namespace}.codex-app ];

      # Let `codex app <dir>` discover an installed desktop app without
      # requiring a mutable /Applications install.
      file."Applications/Codex.app".source =
        "${pkgs.${namespace}.codex-app}/Applications/Codex.app";
    };
  };
}
