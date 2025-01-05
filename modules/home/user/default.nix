{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib)
    types
    mkIf
    mkDefault
    mkMerge
    ;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.user;

  home-directory =
    if cfg.name == null then
      null
    else if pkgs.stdenv.isDarwin then
      "/Users/${cfg.name}"
    else
      "/home/${cfg.name}";

  debugConfig =
    conf:
    builtins.trace ''
      Home Manager Configuration:
        user.name: ${toString config.${namespace}.user.name}
        user.email: ${toString config.${namespace}.user.email}
        user.fullName: ${toString config.${namespace}.user.fullName}
        user.home: ${toString config.${namespace}.user.home}
        user.icon: ${toString config.${namespace}.user.icon}
    '' conf;
in
{
  options.${namespace}.user = {
    enable = mkOpt types.bool false "Whether to configure the user account.";

    email = mkOpt types.str "frankhinek@users.noreply.github.com" "The email of the user.";
    fullName = mkOpt types.str "Frank Hinek" "The full name of the user.";
    home = mkOpt (types.nullOr types.str) home-directory "The user's home directory.";
    icon = mkOpt (types.nullOr types.package) null "The user's profile picture.";
    name = mkOpt (types.nullOr types.str) config.snowfallorg.user.name "The user account.";
    signingKey = mkOpt (types.nullOr types.str) null "The PGP key ID to use for signing.";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      assertions = [
        {
          assertion = cfg.name != null;
          message = "${namespace}.user.name must be set";
        }
        {
          assertion = cfg.email != null;
          message = "${namespace}.user.email must be set";
        }
        {
          assertion = cfg.home != null;
          message = "${namespace}.user.home must be set";
        }
        {
          assertion = cfg.icon == null || builtins.pathExists cfg.icon;
          message = "${namespace}.user.icon must be a path or derivation";
        }
      ];

      home = debugConfig {
        username = mkDefault cfg.name;
        homeDirectory = mkDefault cfg.home;

        file =
          {
            # "Developer/.keep".text = "";
          }
          // lib.optionalAttrs (cfg.icon != null && pkgs.stdenv.isLinux) {
            ".face".source = cfg.icon;
            ".face.icon".source = cfg.icon;
            "Pictures/profile/${cfg.icon.fileName or (builtins.baseNameOf cfg.icon)}".source = cfg.icon;
          };

        # ensures ~/Developer folder exists.
        # this folder is later assumed by other activations, specially on darwin.
        # activation.developer = ''
        #   mkdir -p ~/pup
        # '';
        # activation.setUserPicture = mkIf (cfg.icon != null && pkgs.stdenv.isDarwin) ''
        #     # echo "Setting user picture for ${cfg.name}..."
        #     /usr/bin/dscl . create /Users/${cfg.name} Picture "${cfg.icon}"
        #     mkdir -p ~/pup
        #   '';
      };
    }
  ]);
}
