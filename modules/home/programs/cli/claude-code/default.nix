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

  cfg = config.${namespace}.programs.cli.claude-code;
in
{
  options.${namespace}.programs.cli.claude-code = {
    enable = mkBoolOpt false "Whether to enable Claude Code.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      pkgs.${namespace}.claude-code
    ];
  };
}
