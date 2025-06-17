{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.voiceink;
in
{
  options.${namespace}.programs.gui.voiceink = {
    enable = mkEnableOption "Whether to enable VoiceInk.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "voiceink"
      ];
    };
  };
}
