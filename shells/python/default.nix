{ mkShell, pkgs, ... }:
mkShell {
  packages = with pkgs; [
    black
    (python3.withPackages (
      ps: with ps; [
        flake8
        ipython
        mypy
        pip
        pytest
      ]
    ))
    ruff
  ];

  shellHook = ''
    printf "\n    \033[1;35m🔨 Python DevShell\033[0m\n\n"
    python3 -m venv .venv
    source .venv/bin/activate
  '';
}
