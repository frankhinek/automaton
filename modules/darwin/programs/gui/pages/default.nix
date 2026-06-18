{ config, lib, namespace, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.gui.pages;
in {
  options.${namespace}.programs.gui.pages = {
    enable = mkBoolOpt false "Whether to enable Pages.";
  };

  config =
    mkIf cfg.enable { homebrew = { masApps = { "Pages" = 409201541; }; }; };
}
