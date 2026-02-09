{ config, lib, pkgs, namespace, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.cli.docs-list;
in {
  options.${namespace}.programs.cli.docs-list = {
    enable = mkBoolOpt false "Whether to enable docs-list.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ pkgs.${namespace}.docs-list ];
  };
}
