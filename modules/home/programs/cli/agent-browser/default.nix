{ config, lib, pkgs, namespace, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.cli.agent-browser;
in {
  options.${namespace}.programs.cli.agent-browser = {
    enable = mkBoolOpt false "Whether to enable agent-browser.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ pkgs.${namespace}.agent-browser ];
  };
}
