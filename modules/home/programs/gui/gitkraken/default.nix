{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.gui.gitkraken;
in
{
  options.${namespace}.programs.gui.gitkraken = {
    enable = mkEnableOption "Whether to enable GitKraken.";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        gitkraken
      ];
    };
  };
}
