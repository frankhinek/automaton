{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.system.power;
in
{
  options.${namespace}.system.power = {
    enable = mkEnableOption "Whether to apply macOS power configuration";
  };

  config = mkIf cfg.enable {
    system.activationScripts.postActivation.text = ''
      # Prevent automatic sleeping on power adapter when the display is off.
      /usr/bin/pmset -c sleep 0
      # Set display sleep to 2 minutes on battery
      /usr/bin/pmset -b displaysleep 2
      # Set display sleep to 20 minutes when on power adapter
      /usr/bin/pmset -c displaysleep 20
    '';
  };
}
