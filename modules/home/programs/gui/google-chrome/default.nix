{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.gui.google-chrome;
in
{
  options.${namespace}.programs.gui.google-chrome = {
    enable = mkEnableOption "Whether to enable Google Chrome.";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        nix-unstable.google-chrome
      ];

      # Added for Flutter development so flutter doctor can find Chrome
      sessionVariables = {
        CHROME_EXECUTABLE = "${pkgs.nix-unstable.google-chrome}/Applications/Google Chrome.app/Contents/MacOS/Google Chrome";
      };
    };
  };
}
