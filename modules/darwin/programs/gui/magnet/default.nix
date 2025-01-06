{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.gui.magnet;
in
{
  options.${namespace}.programs.gui.magnet = {
    enable = mkBoolOpt false "Whether to enable Magnet.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      masApps = {
        "Magnet" = 441258766;
      };
    };
  };
}
