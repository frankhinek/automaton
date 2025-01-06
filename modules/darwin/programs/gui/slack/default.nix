{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.slack;
in
{
  options.${namespace}.programs.gui.slack = {
    enable = mkEnableOption "Whether to enable Slack.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "slack"
      ];
    };
  };
}
