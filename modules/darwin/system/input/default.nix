{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkMerge mkEnableOption;

  cfg = config.${namespace}.system.input;
in
{
  options.${namespace}.system.input = {
    enable = mkEnableOption "Whether to apply macOS input configuration";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      system = {
        activationScripts.postActivation.text = ''
          # Clear the UserKeyMapping for the Advantage360 Pro keyboard.
          hidutil property --match '{"VendorID":0x1d50, "ProductID":0x615e}' --set '{"UserKeyMapping": [] }'
        '';

        keyboard = {
          enableKeyMapping = true;
          # Remap the Caps Lock key to Control.
          # remapCapsLockToControl = true;
          # Swap Caps Lock and Left Control keys.
          userKeyMapping = [
            {
              HIDKeyboardModifierMappingSrc = 30064771300;
              HIDKeyboardModifierMappingDst = 30064771129;
            }
            {
              HIDKeyboardModifierMappingSrc = 30064771296;
              HIDKeyboardModifierMappingDst = 30064771129;
            }
            {
              HIDKeyboardModifierMappingSrc = 30064771129;
              HIDKeyboardModifierMappingDst = 30064771300;
            }
          ];
        };

        defaults = {
          # Trackpad settings.
          trackpad = {
            # silent clicking = 0, default = 1
            # ActuationStrength = 0;
            # Enable trackpad tap to click.  The default is false.
            Clicking = true;
            # Enable tap-to-drag. The default is false.
            Dragging = true;
            # firmness level, 0 = lightest, 2 = heaviest
            # FirstClickThreshold = 1;
            # firmness level for force touch
            # SecondClickThreshold = 1;
            # Enable trackpad right click.  The default is false.
            TrackpadRightClick = true;
            # Enable three finger drag.  The default is false.
            # TrackpadThreeFingerDrag = true;
          };

          # ".GlobalPreferences" = {
          #   "com.apple.mouse.scaling" = 1.0;
          # };

          NSGlobalDomain = {
            # AppleKeyboardUIMode = 3;
            # ApplePressAndHoldEnabled = false;

            # KeyRepeat = 1;
            # InitialKeyRepeat = 10;

            NSAutomaticCapitalizationEnabled = false;
            NSAutomaticDashSubstitutionEnabled = false;
            NSAutomaticQuoteSubstitutionEnabled = false;
            NSAutomaticPeriodSubstitutionEnabled = false;
            NSAutomaticSpellingCorrectionEnabled = false;
          };
        };
      };
    }
  ]);
}
