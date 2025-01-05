{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) types mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.cli.fish;
in
{
  options.${namespace}.programs.cli.fish = with types; {
    enable = mkBoolOpt false "Whether to manage fish shell.";
  };

  config = mkIf cfg.enable {
    # Enable fish shell management through home-manager integration.
    programs.fish.enable = true;

    # Add fish to the list of available shells in the system.
    # This makes fish available as a login shell option.
    environment.shells = [ pkgs.fish ];
  };
}
