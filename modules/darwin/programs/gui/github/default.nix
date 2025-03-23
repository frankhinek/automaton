{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.github;
in
{
  options.${namespace}.programs.gui.github = {
    enable = mkEnableOption "Whether to enable GitHub Desktop.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "github"
      ];
    };
  };
}
