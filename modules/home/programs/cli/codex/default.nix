{ config, inputs, lib, pkgs, namespace, ... }:
let
  inherit (lib) mkIf getExe escapeShellArg;
  inherit (lib.${namespace}) mkBoolOpt;
  inherit (inputs) home-manager;

  cfg = config.${namespace}.programs.cli.codex;

  # Codex keeps all of its state under $CODEX_HOME (default ~/.codex).
  codexHome =
    config.home.sessionVariables.CODEX_HOME or "${config.home.homeDirectory}/.codex";
  daemonSettings = "${codexHome}/app-server-daemon/settings.json";
in {
  options.${namespace}.programs.cli.codex = {
    enable = mkBoolOpt false "Whether to enable Codex CLI.";

    daemon.autoUpdate = mkBoolOpt false ''
      Whether the shared app-server daemon may replace its own package with the
      latest upstream release on a timer. Off keeps the daemon on the version
      this Nix package installed. Explicit `codex update` and
      `codex app-server daemon update` are unaffected either way.
    '';
  };

  config = mkIf cfg.enable {
    home = {
      packages = [ pkgs.${namespace}.codex ];

      # The daemon reads this from CODEX_HOME/app-server-daemon/settings.json,
      # not config.toml, and it rewrites that file in place when remote control
      # is toggled. A store symlink would be replaced by a regular file and
      # break the next switch, so merge the key into a regular file instead
      # and leave every other key alone.
      activation.codexDaemonSettings = # bash
        home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          settings=${escapeShellArg daemonSettings}
          enabled=${if cfg.daemon.autoUpdate then "true" else "false"}
          jq=${getExe pkgs.jq}

          current='{}'
          if [ -s "$settings" ]; then
            current="$(cat "$settings")"
          fi

          writeCodexDaemonSettings() {
            mkdir -p "$(dirname "$settings")"
            printf '%s\n' "$updated" > "$settings.hm-tmp"
            chmod 600 "$settings.hm-tmp"
            mv -f "$settings.hm-tmp" "$settings"
          }

          if ! printf '%s' "$current" | "$jq" -e . > /dev/null 2>&1; then
            warnEcho "codex: $settings is not valid JSON; not touching it"
          elif printf '%s' "$current" | "$jq" -e --argjson enabled "$enabled" \
              '.updater.autoUpdateEnabled == $enabled' > /dev/null; then
            : # already in the desired state
          else
            updated="$(printf '%s' "$current" | "$jq" --argjson enabled "$enabled" \
              '.updater.autoUpdateEnabled = $enabled')"
            run writeCodexDaemonSettings
          fi
        '';
    };
  };
}
