{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.gui.xcode;
in
{
  options.${namespace}.programs.gui.xcode = {
    enable = mkBoolOpt false "Whether to enable Xcode.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      masApps = {
        "Xcode" = 497799835;
      };
    };
  };
}
