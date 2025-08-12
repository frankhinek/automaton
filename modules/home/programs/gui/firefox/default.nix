{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) types mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.gui.firefox;
in
{
  options.${namespace}.programs.gui.firefox = with types; {
    enable = mkBoolOpt false "Whether to enable Firefox.";
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = if pkgs.stdenv.isLinux then pkgs.firefox-devedition else null;

      profiles = {
        ${config.${namespace}.user.name} = {
          id = 0; # Unique identifier for the profile
          inherit (config.${namespace}.user) name; # Profile name
          isDefault = true; # Sets this as the default profile

          settings = {
            # AUTOFILL AND FORM SETTINGS
            "browser.formfill.enable" = false; # Disable form autofill
            "extensions.formautofill.addresses.enabled" = false; # Disable address autofill
            "extensions.formautofill.available" = "off"; # Turn off autofill feature
            "extensions.formautofill.creditCards.available" = false; # Disable credit card autofill
            "extensions.formautofill.creditCards.enabled" = false; # Disable credit card autofill
            "extensions.formautofill.heuristics.enabled" = false; # Disable autofill predictions

            # HOMEPAGE AND SEARCH SETTINGS
            "browser.search.defaultenginename" = "Searx"; # Default search engine name
            "browser.search.order.1" = "Searx"; # Primary search engine
            "browser.urlbar.suggest.searches" = false; # Don't suggest searches in URL bar
            "browser.urlbar.shortcuts.bookmarks" = false; # Don't show bookmark shortcuts in URL bar
            "browser.urlbar.shortcuts.history" = false; # Don't show history shortcuts in URL bar
            "browser.urlbar.showSearchSuggestionsFirst" = false; # Don't prioritize search suggestions
            "browser.urlbar.speculativeConnect.enabled" = false; # Don't preload autocomplete URLs
            "browser.newtab.url" = "about:blank"; # Set new tabs to blank page
            "browser.newtabpage.enabled" = false; # Disable new tab page features
            "browser.newtabpage.activity-stream.default.sites" = ""; # Remove default top sites
            "browser.newtabpage.enhanced" = false; # Disable enhanced new tab page
            "browser.newtabpage.introShown" = true; # Don't show new tab page introduction

            # PASSWORD MANAGER SETTINGS
            "signon.rememberSignons" = false; # Disable password manager entirely
            "signon.autofillForms" = false; # Disable auto-filling passwords
            "signon.generation.enabled" = false; # Disable password generation
            "signon.management.page.breach-alerts.enabled" = false; # Disable breach alerts
            "signon.firefoxRelay.feature" = "disabled"; # Disable Firefox Relay integration

            # PRIVACY SETTINGS
            "privacy.donottrackheader.enabled" = true; # Send "Do Not Track" request
            "privacy.fingerprintingProtection" = true; # Block fingerprinting attempts
            "privacy.resistFingerprinting" = true; # Enhanced fingerprinting resistance
            "privacy.trackingprotection.enabled" = true; # Enable tracking protection
            "privacy.trackingprotection.socialtracking.enabled" = true; # Block social media trackers

            # STARTUP SETTINGS
            "browser.startup.page" = 1; # What to show on startup (1 = show homepage)
            "browser.startup.homepage" = "about:blank"; # Sets homepage to blank page
            "browser.shell.checkDefaultBrowser" = false; # Don't check if Firefox is default browser

            # TELEMETRY SETTINGS
            # Developer Edition Data Collection Settings
            "datareporting.healthreport.uploadEnabled" = false; # Disable health report uploads
            "datareporting.policy.dataSubmissionEnabled" = false; # Disable all data submission
            "datareporting.healthreport.service.enabled" = false; # Disable health report service
            "app.shield.optoutstudies.enabled" = false; # Disable shield studies
            # General Technical Data Collection
            "browser.newtabpage.activity-stream.feeds.telemetry" = false; # Disable activity feed data collection
            "browser.newtabpage.activity-stream.telemetry" = false; # Disable new tab page telemetry
            "toolkit.telemetry.unified" = false; # Disable unified telemetry
            "toolkit.telemetry.enabled" = false; # Disable telemetry
            "toolkit.telemetry.server" = ""; # Clear telemetry server
            "toolkit.telemetry.archive.enabled" = false; # Disable telemetry archive
            "toolkit.telemetry.newProfilePing.enabled" = false; # Disable new profile ping
            "toolkit.telemetry.shutdownPingSender.enabled" = false; # Disable shutdown ping
            "toolkit.telemetry.updatePing.enabled" = false; # Disable update ping
            "toolkit.telemetry.bhrPing.enabled" = false; # Disable background hang reporter
            # Study and Report Settings
            "browser.ping-centre.telemetry" = false; # Disable ping centre
            "browser.tabs.crashReporting.sendReport" = false; # Disable crash reports
            "devtools.onboarding.telemetry.logged" = false; # Disable devtools telemetry
          };

          search = {
            force = true; # Forces these search settings
            default = "Searx"; # Sets Searx as the default search engine
            order = [
              "Searx"
              "google"
            ]; # Defines search engine order in the search bar
            engines = {
              "Nix Packages" = {
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };
              "NixOS Wiki" = {
                urls = [ { template = "https://nixos.wiki/index.php?search={searchTerms}"; } ];
                icon = "https://nixos.wiki/favicon.png";
                definedAliases = [ "@nw" ];
              };
              "Searx" = {
                urls = [ { template = "https://searx.aicampground.com/?q={searchTerms}"; } ];
                icon = "https://nixos.wiki/favicon.png";
                definedAliases = [ "@searx" ];
              };
              bing.metaData.hidden = true;
              google.metaData.alias = "@g"; # builtin engines only support specifying one additional alias
            };
          };
          # extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          #   ublock-origin
          #   bitwarden
          #   darkreader
          #   vimium
          # ];
        };
      };
    };
  };
}
