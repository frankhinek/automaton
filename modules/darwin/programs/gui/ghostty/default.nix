{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.ghostty;
in
{
  options.${namespace}.programs.gui.ghostty = {
    enable = mkEnableOption "Whether to enable ghostty.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "ghostty"
      ];
    };

    snowfallorg.users.${config.${namespace}.user.name}.home.config = {
      xdg.configFile = {
        "ghostty/config".source = ./config;
      };
    };
  };
}
