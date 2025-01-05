{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.gui._1password;
in
{
  options.${namespace}.programs.gui._1password = {
    enable = mkBoolOpt false "Whether to enable 1Password.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      # TODO: Figure out if I can remove this. I think this tap adds:
      #       - The 1Password CLI tool (op)
      #       - The 1Password SSH Agent
      #       - Development tools and SDKs for 1Password integrations
      # which can be installed using a Home Manager package as demonstrated here: https://github.com/khaneliman/khanelinix/blob/main/modules/home/programs/terminal/tools/_1password-cli/default.nix
      # taps = [ "1password/tap" ];

      casks = [ "1password" ];

      masApps = mkIf config.${namespace}.programs.cli.homebrew.masEnable {
        "1Password for Safari" = 1569813296;
      };
    };
  };
}
