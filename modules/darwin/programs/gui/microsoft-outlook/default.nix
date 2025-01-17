{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.microsoft-outlook;
in
{
  options.${namespace}.programs.gui.microsoft-outlook = {
    enable = mkEnableOption "Whether to enable Microsoft Outlook.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "microsoft-outlook"
      ];
    };
  };
}
