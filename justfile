default:
    @just --list --unsorted

apply:
    #!/usr/bin/env bash
    if [[ $(uname) == "Darwin" ]]; then
        sudo darwin-rebuild switch --flake .
    else
        nixos-rebuild switch --flake . --use-remote-sudo
    fi

check flake:
    #!/usr/bin/env bash
    if [[ $(uname) == "Darwin" ]]; then
        nom build .#darwinConfigurations.{{ flake }}.system
    else
        nom build .#nixosConfigurations.{{ flake }}.config.system.build.toplevel
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