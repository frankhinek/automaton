{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.programs.cli.tools.direnv;
in
{
  options.${namespace}.programs.cli.tools.direnv = {
    enable = mkBoolOpt false "Whether to enable direnv.";
  };

  config = mkIf cfg.enable {
    # Reduce direnv verbosity and hide env diff output
    xdg.configFile."direnv/direnv.toml".text = ''
      [global]
      hide_env_diff = true
      # Set to "-" to silence all direnv logs; comment out to keep minimal logs
      log_format = "-"
    '';

    programs.direnv = {
      enable = true;
      nix-direnv = enabled;
    };
  };
}
