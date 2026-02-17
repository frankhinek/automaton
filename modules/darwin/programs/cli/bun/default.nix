{ config, lib, pkgs, namespace, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.cli.bun;
  bunInstallDir = "${config.${namespace}.user.home}/.bun";
in {
  options.${namespace}.programs.cli.bun = {
    enable = mkEnableOption "Whether to enable Bun.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ nix-unstable.bun ];

    environment.variables = { BUN_INSTALL = bunInstallDir; };

    environment.systemPath = [ "${bunInstallDir}/bin" ];
  };
}
