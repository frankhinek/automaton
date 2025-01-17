{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.microsoft-office;
in
{
  options.${namespace}.programs.gui.microsoft-office = {
    enable = mkEnableOption "Whether to enable Microsoft Excel, PowerPoint, and Word.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "microsoft-excel"
        "microsoft-powerpoint"
        "microsoft-word"
      ];
    };
  };
}
