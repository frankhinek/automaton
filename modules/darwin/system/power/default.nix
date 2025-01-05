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
      sudo pmset -c sleep 0
    '';
  };
}
