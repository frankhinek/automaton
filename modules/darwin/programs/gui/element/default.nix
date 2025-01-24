{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.element;
in
{
  options.${namespace}.programs.gui.element = {
    enable = mkEnableOption "Whether to enable the Element Matrix collaboration client.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "element"
      ];
    };
  };
}
