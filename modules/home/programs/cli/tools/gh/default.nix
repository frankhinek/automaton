{ config, lib, pkgs, namespace, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.cli.tools.gh;
in {
  options.${namespace}.programs.cli.tools.gh = {
    enable = mkBoolOpt false "Whether to enable gh.";
  };

  config = mkIf cfg.enable {
    programs.gh = {
      enable = true;
      package = pkgs.nix-unstable.gh;

      settings = {
        # Specify protocol per host
        "github.com" = { git_protocol = "https"; };
        editor = "nvim";
        aliases = { co = "pr checkout"; };
      };
    };
  };
}
