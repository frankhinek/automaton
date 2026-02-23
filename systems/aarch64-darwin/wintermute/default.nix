{ inputs, lib, config, namespace, pkgs, system, ... }:
with lib.${namespace};
let
  inherit (inputs) fonts-licensed;
  inherit (lib.${namespace}) enabled;

  inherit (fonts-licensed.packages.${system}) monolisa-nerdfonts;

  debugConfig = conf:
    builtins.trace ''
      Darwin Configuration:
        user.name: ${toString config.${namespace}.user.name}
        user.email: ${toString config.${namespace}.user.email}
        user.fullName: ${toString config.${namespace}.user.fullName}
        user.home: ${toString config.${namespace}.user.home}
    '' conf;
in {
  environment = debugConfig {
    systemPath = lib.mkBefore [ "/opt/homebrew/bin" ];
    variables = { LANG = "en_US.UTF-8"; };
  };

  automaton = {
    user = {
      email = "frankhinek@users.noreply.github.com";
      fullName = "Frank Hinek";
      name = "frank";
      shell = pkgs.fish;
    };

    nix = enabled;

    programs = {
      cli = {
        bun = enabled;
        fish = enabled;
        gpg = enabled;
        homebrew = {
          enable = true;
          masEnable = true;
        };
        somo = enabled;
      };

      gui = {
        _1password = enabled;
        affinity = enabled;
        android-studio = enabled;
        canary = enabled;
        clickup = enabled;
        cursor = enabled;
        docker = enabled;
        elgato = enabled;
        element = enabled;
        figma = enabled;
        firefox = enabled;
        ghostty = enabled;
        github = enabled;
        hoppscotch = enabled;
        legcord = enabled;
        lunar = enabled;
        magnet = enabled;
        microsoft-office = enabled;
        microsoft-outlook = enabled;
        mullvad-vpn = enabled;
        obs = enabled;
        obsidian = enabled;
        raycast = enabled;
        screen-studio = enabled;
        slack = enabled;
        sparrow = enabled;
        steermouse = enabled;
        superwhisper = enabled;
        utm = enabled;
        voiceink = enabled;
        warp = enabled;
        wireguard = enabled;
        xcode = enabled;
        yaak = enabled;
        zen = enabled;
      };
    };

    system = {
      fonts = {
        enable = true;
        fonts = with pkgs; [
          fira-code
          monolisa-nerdfonts
          open-sans
          raleway
          roboto
        ];
      };
      input = enabled;
      interface = enabled;
      power = enabled;
    };
  };

  # Add ability to use TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  system.activationScripts.postActivation.text = lib.mkAfter ''
    user="${config.${namespace}.user.name}"
    uid="$(/usr/bin/id -u "$user")"

    # Reload settings after applying input changes so they take effect immediately
    echo "Reloading system settings immediately as ($user)" >&2
    /usr/bin/sudo -u "$user" /bin/launchctl asuser "$uid" \
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    # Also bounce cfprefsd to ensure new values are read
    /usr/bin/sudo -u "$user" /bin/launchctl asuser "$uid" /usr/bin/killall cfprefsd || true
  '';

  # Required by nix-darwin 25.x for options that apply to the primary user
  system.primaryUser = config.${namespace}.user.name;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
