{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.cli.tools.lsd;
in
{
  options.${namespace}.programs.cli.tools.lsd = {
    enable = mkBoolOpt false "Whether to enable lsd.";
  };

  config = mkIf cfg.enable {
    programs.lsd = {
      enable = true;

      settings = {
        blocks = [
          "permission"
          "user"
          "group"
          "size"
          "date"
          "name"
        ];
        classic = false;
        date = "date";
        dereference = false;
        header = true;
        hyperlink = "auto";
        icons = {
          when = "auto";
          theme = "fancy";
          separator = " ";
        };
        ignore-globs = [ ".git" ];
        indicators = true;
        layout = "grid";
        # permission = "octal";
        sorting = {
          column = "name";
          reverse = false;
          dir-grouping = "first";
        };
        symlink-arrow = "=>";
        # total-size = true;
      };
    };

    home.shellAliases = {
      ls = "${lib.getExe pkgs.lsd} -al";
      lt = "${lib.getExe pkgs.lsd} --tree";
      llt = "${lib.getExe pkgs.lsd} -l --tree";
    };
  };
}
