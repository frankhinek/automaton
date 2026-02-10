{ config, lib, namespace, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.gui.legcord;
in {
  options.${namespace}.programs.gui.legcord = {
    enable = mkBoolOpt false "Whether to enable Legcord.";
  };

  config = mkIf cfg.enable { homebrew = { casks = [ "legcord" ]; }; };
}
