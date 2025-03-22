{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.gui.yaak;
in
{
  options.${namespace}.programs.gui.yaak = {
    enable = mkEnableOption "Whether to enable Yaak REST, GraphQL and gRPC client.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "yaak"
      ];
    };
  };
}
