{ config, lib, namespace, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.gui.garageband;
in {
  options.${namespace}.programs.gui.garageband = {
    enable = mkBoolOpt false "Whether to enable GarageBand.";
  };

  config = mkIf cfg.enable {
    homebrew = { masApps = { "GarageBand" = 682658836; }; };
  };
}
