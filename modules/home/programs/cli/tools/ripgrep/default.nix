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

  cfg = config.${namespace}.programs.cli.tools.ripgrep;
in
{
  options.${namespace}.programs.cli.tools.ripgrep = {
    enable = mkBoolOpt false "Whether to enable ripgrep.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ripgrep
    ];
  };
}
