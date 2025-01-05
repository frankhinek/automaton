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

  cfg = config.${namespace}.programs.cli.tools.wget;
in
{
  options.${namespace}.programs.cli.tools.wget = {
    enable = mkBoolOpt false "Whether to enable wget.";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        wget
      ];

      shellAliases = {
        wget = "${getExe pkgs.wget} -c ";
      };
    };
  };
}
