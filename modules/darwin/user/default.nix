{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) types mkIf mkMerge;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.user;

  home-directory =
    if cfg.name == null then
      null
    else if pkgs.stdenv.isDarwin then
      "/Users/${cfg.name}"
    else
      "/home/${cfg.name}";
in
{
  options.${namespace}.user = {
    email = mkOpt (types.nullOr types.str) null "The email of the user.";
    fullName = mkOpt (types.nullOr types.str) null "The full name of the user.";
    home = mkOpt (types.nullOr types.str) home-directory "The user's home directory.";
    name = mkOpt (types.nullOr types.str) null "The user account.";
    shell = mkOpt (types.nullOr types.package) null "The user's login shell.";
    uid = mkOpt (types.nullOr types.int) 501 "The uid for the user account.";
  };

  config = mkMerge [
    {
      assertions = [
        {
          assertion = cfg.name != null;
          message = "${namespace}.user.name must be set in systems/*-darwin/<hostname>";
        }
        {
          assertion = cfg.home != null;
          message = "${namespace}.user.name must be set in systems/*-darwin/<hostname>";
        }
        {
          assertion = cfg.email != null;
          message = "${namespace}.user.email must be set in systems/*-darwin/<hostname>";
        }
        {
          assertion = cfg.fullName != null;
          message = "${namespace}.user.fullName must be set in systems/*-darwin/<hostname>";
        }
      ];

      # Add user to nix-darwin's knownUsers list to enable management of user attributes
      # like login shell. Without this, nix-darwin won't modify user settings in macOS's
      # Directory Services, even if configured in users.users.<name>.
      users.knownUsers = [ cfg.name ];

      users.users.${cfg.name} = {
        description = cfg.fullName;
        inherit (cfg) home;
        inherit (cfg) name;
        inherit (cfg) shell;
        # NOTE: Setting the uid here is required for another module to evaluate
        # successfully since it reads `users.users.${automaton.user.name}.uid`.
        uid = mkIf (cfg.uid != null) cfg.uid;
      };

      snowfallorg.users.${config.${namespace}.user.name}.home.config = {
        home = {
          file = {
            ".profile".text = ''
              # The default file limit is far too low and throws an error when rebuilding the system.
              # See the original with: ulimit -Sa
              ulimit -n 4096
            '';
          };
        };
      };
    }
  ];
}
