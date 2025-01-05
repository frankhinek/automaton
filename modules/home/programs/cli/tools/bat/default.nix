{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) getExe mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.cli.tools.bat;
in
{
  options.${namespace}.programs.cli.tools.bat = {
    enable = mkBoolOpt false "Whether to enable bat.";
  };

  config = mkIf cfg.enable {
    programs.bat = {
      enable = true;

      config = {
        pager = "never";
        style = "grid,header-filename,header-filesize";
        theme = "Dracula";
      };

      extraPackages = with pkgs.bat-extras; [
        batdiff
        batgrep
        batman
        batpipe
        batwatch
        prettybat
      ];
    };

    home.shellAliases = {
      # cat = "${getExe pkgs.bat} --style=plain";
      cat = "${getExe pkgs.bat}";
      man = "batman";
    };
  };
}
