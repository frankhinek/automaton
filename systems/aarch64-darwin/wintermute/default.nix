#{ pkgs, lib, ... }:
{
  lib,
  config,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib.${namespace}) enabled;

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
        docker = enabled;
        ghostty = enabled;
      };
    };

    system = {
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
