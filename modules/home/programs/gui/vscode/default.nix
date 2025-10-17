{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.gui.vscode;

  # Custom marketplace extensions that are not packaged with nixpkgs.
  # Determine sha256 hash using: nix-prefetch-url https://marketplace.visualstudio.com/_apis/public/gallery/publishers/miguelsolorio/vsextensions/fluent-icons/0.0.19/vspackage
  fluent-icons = pkgs.vscode-utils.extensionFromVscodeMarketplace {
    name = "fluent-icons";
    publisher = "miguelsolorio";
    version = "0.0.19";
    sha256 = "17rplc681rjpskn9h7lk02349j57vqyp7d7q76c3z9cs8j3x5wrr";
  };
in
{
  options.${namespace}.programs.gui.vscode = {
    enable = mkEnableOption "Whether to enable vscode.";
    declarativeConfig = mkBoolOpt false "Whether to apply a custom vscode configuration.";
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscode;

      profiles = {
        default = lib.mkMerge [
          {
            enableUpdateCheck = true;

            extensions = with pkgs.vscode-extensions; [
              enkia.tokyo-night
              fluent-icons
              jnoortheen.nix-ide
              pkief.material-icon-theme
              rust-lang.rust-analyzer
              bradlc.vscode-tailwindcss
              github.vscode-github-actions
            ];

            keybindings = [
              {
                key = "cmd+k cmd+e";
                command = "workbench.view.explorer";
              }
              {
                key = "cmd+k cmd+f";
                command = "workbench.view.search";
              }
              {
                key = "cmd+k cmd+g";
                command = "workbench.view.scm";
              }
              {
                key = "cmd+k cmd+d";
                command = "workbench.view.debug";
              }
              {
                key = "cmd+k cmd+x";
                command = "workbench.view.extensions";
              }
              {
                command = "workbench.action.terminal.sendSequence";
                key = "shift+enter";
                args = {
                  text = " \r";
                };
                when = "terminalFocus";
              }
            ];
          }
          (mkIf cfg.declarativeConfig {
            userSettings = {
              # Color theme
              "material-icon-theme.folders.theme" = "none";
              "workbench.colorTheme" = "Tokyo Night";
              "workbench.iconTheme" = "material-icon-theme";

              # Editor Appearance
              "editor.minimap.enabled" = false;
              "editor.renderWhitespace" = "trailing";
              "editor.rulers" = [
                80
                100
              ];
              "editor.tabSize" = 2;
              "workbench.editor.tabActionCloseVisibility" = false;
              "workbench.productIconTheme" = "fluent-icons";
              "workbench.sideBar.location" = "right";

              # Typography
              "editor.fontFamily" = "MonoLisa Nerd Font"; # (Default: Menlo, Monaco, 'Courier New', monospace)
              "editor.fontLigatures" = "'ss02' on, 'calt' on, 'liga' on, 'zero' on"; # (Default: null)
              "editor.fontSize" = 14; # (Default: 12)
              "editor.lineHeight" = 0; # (Default: 0 - automatic)

              # Terminal
              "terminal.integrated.defaultProfile.osx" = "fish"; # (Default: "bash")
              "terminal.integrated.fontLigatures.enabled" = true; # (Default: false)
              "terminal.integrated.fontSize" = 13; # (Default: 12)
              "terminal.integrated.lineHeight" = 0; # (Default: 0 - automatic)
            };
          })
        ];
      };
    };
  };
}
