{
  config,
  lib,
  pkgs,
  osConfig,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.cli.shells.fish;
in
{
  options.${namespace}.programs.cli.shells.fish = {
    enable = mkBoolOpt false "Whether to enable fish.";
  };

  config = mkIf cfg.enable {
    xdg.configFile."fish/functions" = {
      source = lib.cleanSourceWith { src = lib.cleanSource ./functions/.; };
      recursive = true;
    };

    programs.fish = {
      enable = true;

      loginShellInit =
        let
          # This naive quoting is good enough in this case. There shouldn't be any
          # double quotes in the input string, and it needs to be double quoted in case
          # it contains a space (which is unlikely!)
          dquote = str: "\"" + str + "\"";

          makeBinPathList = map (path: path + "/bin");
        in
        lib.optionalString pkgs.stdenv.isDarwin ''
          export NIX_PATH="darwin-config=$HOME/.nixpkgs/darwin-configuration.nix:$HOME/.nix-defexpr/channels:$NIX_PATH"
          fish_add_path --move --prepend --path ${
            lib.concatMapStringsSep " " dquote (makeBinPathList osConfig.environment.profiles)
          }
        '';

      interactiveShellInit =
        ''
          # 1password plugin
          if [ -f ~/.config/op/plugins.sh ];
              source ~/.config/op/plugins.sh
          end
        ''
        + lib.optionalString pkgs.stdenv.isDarwin ''
          # Nix
          if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish' ];
           source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
          end
          if [ -f '/nix/var/nix/profiles/default/etc/profile.d/nix.fish' ];
           source '/nix/var/nix/profiles/default/etc/profile.d/nix.fish'
          end
          # End Nix
        ''
        + ''
          # Disable greeting
          set fish_greeting

          ${lib.optionalString config.programs.fastfetch.enable "fastfetch"}
        '';

      plugins = [
        {
          name = "autopair";
          inherit (pkgs.fishPlugins.autopair) src;
        }
      ];
    };
  };
}
