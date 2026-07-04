{ config, lib, namespace, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.gui._1password;
in {
  options.${namespace}.programs.gui._1password = {
    enable = mkBoolOpt false "Whether to enable 1Password.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [ "1password" ];

      masApps = mkIf config.${namespace}.programs.cli.homebrew.masEnable {
        "1Password for Safari" = 1569813296;
      };
    };
  };
}
