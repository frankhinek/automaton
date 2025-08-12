{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.cursor;
in
{
  options.${namespace}.programs.gui.cursor = {
    enable = mkEnableOption "Whether to enable Cursor.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "cursor"
      ];
    };

    snowfallorg.users.${config.${namespace}.user.name}.home.config = {
      home.file."Library/Application Support/Cursor/User/keybindings.json".source = ./keybindings.json;
      home.file."Library/Application Support/Cursor/User/settings.json".source = ./settings.json;
    };
  };
}
