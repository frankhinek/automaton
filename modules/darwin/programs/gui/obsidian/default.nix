{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.obsidian;
in
{
  options.${namespace}.programs.gui.obsidian = {
    enable = mkEnableOption "Whether to enable Obsidian.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "obsidian"
      ];
    };
  };
}
