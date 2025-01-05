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
in
{
  options.${namespace}.programs.gui.vscode = {
    enable = mkEnableOption "Whether to enable vscode.";
    declarativeConfig = mkBoolOpt false "Whether to apply a custom vscode configuration.";
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      enableUpdateCheck = true;
      package = pkgs.vscode;

      extensions = with pkgs.vscode-extensions; [
        enkia.tokyo-night
        jnoortheen.nix-ide
        rust-lang.rust-analyzer
      ];

      userSettings = mkIf cfg.declarativeConfig {
        # Color theme
        "workbench.colorTheme" = "Tokyo Night";
      };
    };
  };
}
