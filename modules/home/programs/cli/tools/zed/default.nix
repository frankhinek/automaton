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

  cfg = config.${namespace}.programs.cli.tools.zed;
in
{
  options.${namespace}.programs.cli.tools.zed = {
    enable = mkBoolOpt false "Whether to enable Zed.";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        nix-unstable.zed-editor
      ];
    };
  };
}
