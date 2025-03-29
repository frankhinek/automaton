{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
with lib.${namespace};
let
  automatonDir = "$HOME/.automaton";
  projectsDir = "$HOME/Developer";
in
{
  automaton = {
    user = {
      enable = true;
      inherit (config.snowfallorg.user) name;
      email = "frankhinek@users.noreply.github.com";
      icon = pkgs.${namespace}.user-icon;
      signingKey = "9F723C168A6F2FC0";
    };

    programs = {
      cli = {
        shells = {
          fish = enabled;
        };

        tools = {
          bat = enabled;
          comma = enabled;
          curl = enabled;
          direnv = enabled;
          eza = enabled;
          gh = enabled;
          git = {
            enable = true;
            inherit (config.${namespace}.user) signingKey;
            signByDefault = true;
          };
          home-manager = enabled;
          jq = enabled;
          just = enabled;
          lsd = enabled;
          wget = enabled;
          zoxide = enabled;
        };
      };

      gui = {
        discord = enabled;
        firefox = enabled;
        gitkraken = enabled;
        vscode = {
          enable = true;
          declarativeConfig = true;
        };
      };
    };
  };

  home = {
    # Ensures the projects directory exists.
    # This directory is later assumed by other activations.
    activation.developer = ''
      mkdir -p ${projectsDir}
    '';

    sessionVariables = {
      AUTOMATON_HOME = automatonDir;
      LC_ALL = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      PROJECTS = projectsDir;
    };

    stateVersion = "24.11";
  };
}
