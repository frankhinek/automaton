default:
    @just --list --unsorted

apply:
    #!/usr/bin/env bash
    if [[ $(uname) == "Darwin" ]]; then
        nix run nix-darwin -- switch --flake .
    else
        nixos-rebuild switch --flake . --use-remote-sudo
    fi

clean:
    #!/usr/bin/env bash
    nix-collect-garbage -d --delete-older-than 30d

sync:
    #!/usr/bin/env bash
    git pull --rebase origin main
    just update
    just clean
    just apply

update:
    nix flake update