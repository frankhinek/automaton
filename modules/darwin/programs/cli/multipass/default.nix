{ config, lib, namespace, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.cli.multipass;
in {
  options.${namespace}.programs.cli.multipass = {
    enable = mkEnableOption "Whether to enable Multipass.";
  };

  config = mkIf cfg.enable { homebrew = { casks = [ "multipass" ]; }; };
}
