{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.android-studio;
in
{
  options.${namespace}.programs.gui.android-studio = {
    enable = mkEnableOption "Whether to enable Android Studio.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "android-studio"
      ];
    };
  };
}
