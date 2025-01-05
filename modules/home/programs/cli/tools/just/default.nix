{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) getExe mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.cli.tools.just;
in
{
  options.${namespace}.programs.cli.tools.just = {
    enable = mkBoolOpt false "Whether to enable just.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      just
    ];

    home.shellAliases = {
      j = "${getExe pkgs.just}";
    };
  };
}
