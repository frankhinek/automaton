{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.cli.codex;
in
{
  options.${namespace}.programs.cli.codex = {
    enable = mkBoolOpt false "Whether to enable Codex CLI.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      pkgs.${namespace}.codex
    ];
  };
}
