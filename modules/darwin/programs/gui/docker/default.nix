{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.docker;
in
{
  options.${namespace}.programs.gui.docker = {
    enable = mkEnableOption "Whether to enable Docker.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "docker-desktop"
      ];
    };
  };
}
