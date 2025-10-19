{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.cli.somo;
in
{
  options.${namespace}.programs.cli.somo = {
    enable = mkBoolOpt false "Whether to enable Somo.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      brews = [
        "somo"
      ];
    };
  };
}
