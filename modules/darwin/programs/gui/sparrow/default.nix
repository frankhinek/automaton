{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.sparrow;
in
{
  options.${namespace}.programs.gui.sparrow = {
    enable = mkEnableOption "Whether to enable Sparrow Wallet.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "sparrow"
      ];
    };
  };
}
