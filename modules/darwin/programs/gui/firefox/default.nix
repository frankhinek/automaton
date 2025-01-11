{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.firefox;
in
{
  options.${namespace}.programs.gui.firefox = {
    enable = mkEnableOption "Whether to enable Firefox.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "firefox@developer-edition"
      ];
    };
  };
}
