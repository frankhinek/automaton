{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.gui.canary;
in
{
  options.${namespace}.programs.gui.canary = {
    enable = mkBoolOpt false "Whether to enable Canary.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      masApps = {
        "Canary Mail App" = 1236045954;
      };
    };
  };
}
