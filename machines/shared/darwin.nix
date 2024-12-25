{ pkgs, ... }:
{
  nixpkgs.config = {
    # Allow installation of packages that do not comply with the Free
    # Software Foundation's (FSF) definition of free software.
    allowUnfree = true;
  };
  services = {
    nix-daemon = {
      enable = true;
    };
  };
  nix = {
      package = pkgs.nix;
      settings = {
          experimental-features = "nix-command flakes";
          trusted-users = [
            "root"
            "frank"
          ];
      };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # Unlock sudo commands with Touch ID instead of typing the password.
  security.pam.enableSudoTouchIdAuth = true;

  users.users.frank = {
    name = "frank";
    home = "/Users/frank";
  };

  homebrew = {
    enable = true;
    casks = [
      "1password"
      "appcleaner"
      "arc"
      "cleanshot"
      "google-chrome"
      "imageoptim"
      "monodraw"
      "signal"
      "slack"
      "telegram"
      "whatsapp"
      "zoom"
    ];
    # masApps = {
    #  "1Password for Safari" = 1569813296;
    #  "Lungo" = 1263070803;
    # };
  };

  system = {
    defaults = {
      dock = {
        autohide = true;
        autohide-delay = 0.0;
        orientation = "bottom";
        tilesize = 42;
        showhidden = true;
        show-recents = true;
        show-process-indicators = true;
        expose-animation-duration = 0.1;
        expose-group-apps = true;
        launchanim = false;
        mineffect = "scale";
        mru-spaces = false;
        screencapture.location = "~/Pictures/screenshots";
        persistent-apps = [
          "/Applications/Arc.app"
          "/Applications/Slack.app"
        ];
      };
      NSGlobalDomain = {
        ApplePressAndHoldEnabled = true;
        KeyRepeat = 2;
        InitialKeyRepeat = 30;
        AppleShowScrollBars = "Always";
        NSWindowResizeTime = 0.1;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        AppleInterfaceStyle = "Dark";
        NSDocumentSaveNewDocumentsToCloud = false;
        _HIHideMenuBar = false;
        "com.apple.springing.delay" = 0.0;
      };
      finder = {
        FXPreferredViewStyle = "Nlsv";
        _FXShowPosixPathInTitle = true;
        FXEnableExtensionChangeWarning = false;
        AppleShowAllFiles = true;
        ShowStatusBar = true;
        ShowPathbar = true;
      };
      CustomUserPreferences = {
        "com.apple.NetworkBrowser" = {
          BrowseAllInterfaces = true;
        };
        "com.apple.screensaver" = {
          askForPassword = true;
          askForPasswordDelay = 0;
        };
        "com.apple.trackpad" = {
          # Default is 0.6875
          scaling = 1;
        };
        "com.apple.mouse" = {
          # Default is 0.875
          scaling = 1;
        };
        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = false;
        };
        "com.apple.LaunchServices" = {
          LSQuarantine = true;
        };
        "com.apple.finder" = {
          ShowExternalHardDrivesOnDesktop = false;
          ShowRemovableMediaOnDesktop = false;
          WarnOnEmptyTrash = false;
        };
        "NSGlobalDomain" = {
          NSNavPanelExpandedStateForSaveMode = true;
          NSTableViewDefaultSizeMode = 1;
          WebKitDeveloperExtras = true;
        };
        "com.apple.ImageCapture" = {
          "disableHotPlug" = true;
        };
        "com.apple.dock" = {
          size-immutable = true;
        };
        "com.apple.Safari" = {
          IncludeInternalDebugMenu = true;
          IncludeDevelopMenu = true;
          WebKitDeveloperExtrasEnabledPreferenceKey = true;
          ShowFullURLInSmartSearchField = true;
          AutoOpenSafeDownloads = false;
          HomePage = "";
          AutoFillCreditCardData = false;
          AutoFillFromAddressBook = false;
          AutoFillMiscellaneousForms = false;
          AutoFillPasswords = false;
          "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
          AlwaysRestoreSessionAtLaunch = 1;
          ExcludePrivateWindowWhenRestoringSessionAtLaunch = 1;
          ShowBackgroundImageInFavorites = 0;
          ShowFrequentlyVisitedSites = 1;
          ShowHighlightsInFavorites = 1;
          ShowPrivacyReportInFavorites = 1;
          ShowRecentlyClosedTabsPreferenceKey = 1;
        };
      };
    };
  };
}