{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.hoppscotch;
in
{
  options.${namespace}.programs.gui.hoppscotch = {
    enable = mkEnableOption "Whether to enable Hoppscotch.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "hoppscotch"
      ];
    };
  };
}
