{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.cli.homebrew;
in
{
  options.${namespace}.programs.cli.homebrew = {
    enable = mkBoolOpt false "Whether to enable homebrew.";
    masEnable = mkBoolOpt false "Whether to enable Mac App Store downloads.";
  };

  config = mkIf cfg.enable {
    # https://docs.brew.sh/Manpage#environment
    environment.variables = {
      HOMEBREW_BAT = "1";
      HOMEBREW_NO_ANALYTICS = "1";
      HOMEBREW_NO_INSECURE_REDIRECT = "1";
    };

    homebrew = {
      enable = true;

      caskArgs.appdir = "/Applications";

      global = {
        autoUpdate = false;
        brewfile = true;
      };

      onActivation = {
        autoUpdate = false;
        cleanup = "zap";
        upgrade = false;
      };

      taps = [
        "homebrew/bundle"
        "homebrew/services"
      ];
    };
  };
}
