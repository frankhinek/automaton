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
    mkEnableOption
    mkIf
    getExe'
    ;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.programs.cli.gpg;

  gpgAgentConf = ''
    ################################################################################
    # GnuPG Agent Configuration
    #
    # https://www.gnupg.org/documentation/manuals/gnupg/Agent-Options.html

    # (Cache-Options) 
    # Set the time a cache entry is valid to n seconds. The default is 600 seconds.
    # Each time a cache entry is accessed, the entry's timer is reset. Setting a
    # value of 0 disables the cache.
    default-cache-ttl 3600
    # Set the maximum time a cache entry is valid to n seconds. After this time, a
    # cache entry will be expired even if it has been accessed recently. The default
    # is 7200 seconds.
    max-cache-ttl 3600

    # (Pinentry-Options)
    # Specify the path to the pinentry program. If not specified, gpg-agent searches
    # for a pinentry in common locations. This setting is required for GUI password
    # prompts on macOS.
    pinentry-program ${getExe' pkgs.pinentry_mac "pinentry-mac"}

    # (SSH-Support-Options)
    # Enable the OpenSSH Agent emulation. This allows GPG keys to be used for SSH
    # authentication, providing a single key management solution.
    enable-ssh-support
  '';
in
{
  options.${namespace}.programs.cli.gpg = {
    enable = mkEnableOption "Whether to enable GnuPG";
    agentTimeout = mkOpt types.int 5 "The amount of time to wait before continuing with shell init.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gnupg
      pinentry_mac
    ];

    # environment.shellInit = # bash
    #   ''
    #     export GPG_TTY="$(tty)"
    #     export SSH_AUTH_SOCK=$(${getExe' pkgs.gnupg "gpgconf"} --list-dirs agent-ssh-socket)

    #     ${getExe' pkgs.coreutils "timeout"} ${builtins.toString cfg.agentTimeout} ${getExe' pkgs.gnupg "gpgconf"} --launch gpg-agent
    #     gpg_agent_timeout_status=$?

    #     if [ "$gpg_agent_timeout_status" = 124 ]; then
    #       # Command timed out...
    #       echo "GPG Agent timed out..."
    #       echo 'Run "gpgconf --launch gpg-agent" to try and launch it again.'
    #     fi
    #   '';

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    ${namespace}.home.file = {
      ".gnupg/gpg.conf".source = ./gpg.conf;
      ".gnupg/gpg-agent.conf".text = gpgAgentConf;
    };
  };
}
