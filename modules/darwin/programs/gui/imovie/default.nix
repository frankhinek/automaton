{ config, lib, namespace, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.gui.imovie;
in {
  options.${namespace}.programs.gui.imovie = {
    enable = mkBoolOpt false "Whether to enable iMovie.";
  };

  config =
    mkIf cfg.enable { homebrew = { masApps = { "iMovie" = 408981434; }; }; };
}
