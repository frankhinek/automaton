{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.system.interface;
in
{
  options.${namespace}.system.interface = {
    enable = mkEnableOption "Whether to apply macOS interface configuration";
  };

  config = mkIf cfg.enable {
    system.defaults = {
      controlcenter = {
        # Show a bluetooth control in menu bar. Default is null.
        # Apple menu > System Preferences > Control Center > Bluetooth
        Bluetooth = true;
      };

      CustomUserPreferences = {
        "com.apple.dock" = {
          # Lock the dock size so it cannot be changed by dragging the separator. Default is false.
          size-immutable = true;
        };

        "com.apple.Safari" = {
          # Do not prompt user to make Safari their default browser
          DefaultBrowserPromptingState3 = 4;

          # Disable click tracking for ads
          # (Settings > Advanced > Privacy > Allow privacy-preserving measurement of ad effectiveness)
          "WebKitPreferences.privateClickMeasurementEnabled" = 0;

          # Open new windows and tabs with an empty page
          # (Settings > General)
          NewTabBehavior = 1;
          NewTabPageSetByUserGesture = 1;
          NewWindowBehavior = 1;

          # Disable favorites in the search bar
          # (Settings > Search > Show Favorites)
          ShowFavoritesUnderSmartSearchField = false;

          # Enable Safari's Debug Menu
          IncludeInternalDebugMenu = true;

          # Show the full URL in the address bar
          # (Settings > Advanced > Show full website address)
          ShowFullURLInSmartSearchField = true;

          # Do not open "safe" files automatically after download
          # (Settings > General > Open "safe" files after downloading)
          AutoOpenSafeDownloads = false;

          # Set Safari’s home page to `about:blank` for faster loading
          # (Settings > General > Homepage > about:blank)
          HomePage = "about:blank";

          # Disable autofill contacts, usernames/passwords, credit cards, and form data
          # (Settings > AutoFill)
          AutoFillCreditCardData = false;
          AutoFillFromAddressBook = false;
          AutoFillMiscellaneousForms = false;
          AutoFillPasswords = false;

          # Do not always restore sessions at launch and do not restore private windows
          AlwaysRestoreSessionAtLaunch = true;
          ExcludePrivateWindowWhenRestoringSessionAtLaunch = true;

          # Show Develop menu
          # (Settings > Advanced > Show features for web developers)
          IncludeDevelopMenu = 1;
          MobileDeviceRemoteXPCEnabled = 1;
          PreferencesModulesMinimumWidths.DeveloperMenuVisibility = 1;
          WebKitDeveloperExtrasEnabledPreferenceKey = 1;
          WebKitPreferences.developerExtrasEnabled = 1;

          # Disable widgets on start page
          ShowBackgroundImageInFavorites = 0;
          ShowFavorites = 0;
          ShowFrequentlyVisitedSites = 0;
          ShowHighlightsInFavorites = 0;
          ShowPrivacyReportInFavorites = 0;
          ShowReadingListInFavorites = 0;

          # Enable continuous spellchecking (add red dots below mispelled words)
          WebContinuousSpellCheckingEnabled = 1;
          # Disable auto-correct
          WebAutomaticSpellingCorrectionEnabled = 0;
        };
      };

      # Dock configuration
      dock = {
        # Automatically hide and show the dock (default: false)
        autohide = true;
        # Eliminate the autohide delay (default: 0.24)
        autohide-delay = 0.0;
        # Minimize windows into their application icon (default: false)
        minimize-to-application = true;
        # Enable highlight hover effect for the grid view of a stack in the Dock (default: false)
        mouse-over-hilite-stack = true;
        # Do not automatically rearrange spaces based on most recent use (default: true)
        mru-spaces = false;
        # Position of the dock on screen (default: "bottom")
        orientation = "bottom";
        # Show indicator lights for open applications in the Dock (default: true)
        show-process-indicators = true;
        # Do not show recent applications in the dock (default: true)
        show-recents = false;
        # Make icons of hidden applications translucent (default: false)
        showhidden = true;
        # Size of the icons in the dock (default: 64)
        tilesize = 50;

        # Persistent applications in the dock.
        persistent-apps = [
          "/Applications/Thunderbird.app"
          "/System/Applications/Messages.app"
          "/Applications/Slack.app"
          "${pkgs.discord}/Applications/Discord.app"
          # { spacer.small = true; }
          "/Applications/Arc.app"
          "/System/Cryptexes/App/System/Applications/Safari.app"
          # { spacer.small = true; }
          "${pkgs.vscode}/Applications/Visual Studio Code.app"
          # { spacer.small = true; }
          "/Applications/Ghostty.app"
        ];
      };

      # Finder configuration
      finder = {
        # Show all file extensions in Finder (default: false)
        AppleShowAllExtensions = true;
        # Default search scope: SCcf = Current Folder (default: "SCev" = This Mac)
        FXDefaultSearchScope = "SCcf";
        # List folders before files when sorting (default: false)
        _FXSortFoldersFirst = true;
        # Show the path bar at bottom of Finder windows (default: false)
        ShowPathbar = true;
        # Show the status bar at bottom of Finder windows (default: false)
        ShowStatusBar = true;
      };
    };
  };
}
