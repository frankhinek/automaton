{ config, lib, namespace, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.gui.numbers;
in {
  options.${namespace}.programs.gui.numbers = {
    enable = mkBoolOpt false "Whether to enable Numbers.";
  };

  config =
    mkIf cfg.enable { homebrew = { masApps = { "Numbers" = 361304891; }; }; };
}
