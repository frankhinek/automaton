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

  cfg = config.${namespace}.programs.cli.tools.curl;
in
{
  options.${namespace}.programs.cli.tools.curl = {
    enable = mkBoolOpt false "Whether to enable curl.";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        curl
      ];
    };
  };
}
