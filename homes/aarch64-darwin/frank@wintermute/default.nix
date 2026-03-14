{ config, lib, namespace, pkgs, ... }:
with lib.${namespace};
let
  automatonDir = "$HOME/.automaton";
  projectsDir = "$HOME/Developer";
in {
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
        claude-code = enabled;
        codex = enabled;
        docs-list = enabled;
        lima = enabled;

        shells = { fish = enabled; };

        tools = {
          bat = enabled;
          comma = enabled;
          curl = enabled;
          devenv = enabled;
          direnv = enabled;
          eza = enabled;
          gh = enabled;
          neovim = enabled;
          git = {
            enable = true;
            inherit (config.${namespace}.user) signingKey;
            signByDefault = true;
          };
          home-manager = enabled;
          jq = enabled;
          just = enabled;
          lsd = enabled;
          ripgrep = enabled;
          wget = enabled;
          zed = enabled;
          zoxide = enabled;
        };
      };

      gui = {
        brave = enabled;
        codex-app = enabled;
        firefox = enabled;
        google-chrome = enabled;
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
