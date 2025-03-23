{
  inputs,
  lib,
  config,
  namespace,
  pkgs,
  system,
  ...
}:
with lib.${namespace};
let
  inherit (inputs) fonts-licensed;
  inherit (lib.${namespace}) enabled;

  inherit (fonts-licensed.packages.${system}) monolisa-nerdfonts;

  debugConfig =
    conf:
    builtins.trace ''
      Darwin Configuration:
        user.name: ${toString config.${namespace}.user.name}
        user.email: ${toString config.${namespace}.user.email}
        user.fullName: ${toString config.${namespace}.user.fullName}
        user.home: ${toString config.${namespace}.user.home}
        knownUsers: ${builtins.toJSON config.users.knownUsers}
    '' conf;
in
{
  environment = debugConfig {
    systemPath = lib.mkBefore [ "/opt/homebrew/bin" ];
    variables = {
      LANG = "en_US.UTF-8";
    };
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
        fish = enabled;
        gpg = enabled;
        homebrew = {
          enable = true;
          masEnable = true;
        };
      };

      gui = {
        _1password = enabled;
        affinity = enabled;
        android-studio = enabled;
        arc = enabled;
        cursor = enabled;
        docker = enabled;
        elgato = enabled;
        element = enabled;
        figma = enabled;
        firefox = enabled;
        ghostty = enabled;
        github = enabled;
        lunar = enabled;
        magnet = enabled;
        microsoft-office = enabled;
        microsoft-outlook = enabled;
        mullvad-vpn = enabled;
        obs = enabled;
        obsidian = enabled;
        raycast = enabled;
        slack = enabled;
        steermouse = enabled;
        superwhisper = enabled;
        thunderbird = enabled;
        utm = enabled;
        windsurf = enabled;
        xcode = enabled;
        yaak = enabled;
        zoom = enabled;
      };
    };

    system = {
      fonts = {
        enable = true;
        fonts = with pkgs; [
          fira-code
          monolisa-nerdfonts
          open-sans
        ];
      };
      input = enabled;
      interface = enabled;
      power = enabled;
    };
  };

  # Add ability to use TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  system.activationScripts.postUserActivation.text = ''
    # Reload system settings immediately instead of waiting for next login.
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
