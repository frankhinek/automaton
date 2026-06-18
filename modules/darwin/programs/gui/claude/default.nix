{ config, lib, namespace, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.claude;
in {
  options.${namespace}.programs.gui.claude = {
    enable = mkEnableOption "Whether to enable Claude Desktop.";
  };

  config = mkIf cfg.enable { homebrew = { casks = [ "claude" ]; }; };
}
