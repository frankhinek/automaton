{ config, lib, namespace, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.gui.keynote;
in {
  options.${namespace}.programs.gui.keynote = {
    enable = mkBoolOpt false "Whether to enable Keynote.";
  };

  config =
    mkIf cfg.enable { homebrew = { masApps = { "Keynote" = 409183694; }; }; };
}
