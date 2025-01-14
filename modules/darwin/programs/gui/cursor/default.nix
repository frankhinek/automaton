{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.cursor;
in
{
  options.${namespace}.programs.gui.cursor = {
    enable = mkEnableOption "Whether to enable Cursor.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "cursor"
      ];
    };
  };
}
