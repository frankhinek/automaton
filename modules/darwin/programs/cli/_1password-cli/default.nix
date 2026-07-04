{ config, lib, namespace, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.cli._1password-cli;
in {
  options.${namespace}.programs.cli._1password-cli = {
    enable = mkBoolOpt false "Whether to enable the 1Password CLI.";
  };

  config = mkIf cfg.enable { homebrew = { casks = [ "1password-cli" ]; }; };
}
