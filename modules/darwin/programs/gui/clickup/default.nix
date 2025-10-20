{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.gui.clickup;
in
{
  options.${namespace}.programs.gui.clickup = {
    enable = mkBoolOpt false "Whether to enable ClickUp.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [ "clickup" ];
    };
  };
}
