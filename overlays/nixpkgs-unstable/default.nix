# This approach enables you to specify unstable packages using the
# nix-unstable prefix.  For example, stable firefox would be pkgs.firefox
# and unstable firefox would be pkgs.nix-unstable.firefox.
# Reference: https://gitlab.com/usmcamp0811/dotfiles/-/blob/nixos/overlays/nix-unstable/default.nix?ref_type=heads
{ nixpkgs-unstable, ... }:
_final: prev: {
  nix-unstable = import nixpkgs-unstable {
    inherit (prev) system;
    config = {
      allowUnfree = true;
    };
  };
}

# Alternative approach the defines specific packages which will be overriden
# with the nixpkgs unstable channel version. The drawback to this approach is
# that it isn't clear in a configuration file that a particular package is
# being pulled from the unstable channel. For example, based on the config
# below if someone were to specify pkgs.firefox it would be the version from
# the stable nixpkgs channel but if they specify pkgs.firefox-devedition it
# would be the nixpkgs-unstable version.
# specify pkgs.firefox
# { channels, ... }:
# _final: _prev: {
#   inherit (channels.nixpkgs-unstable)
#     firefox-devedition
#     firefox-devedition-unwrapped
#     firefox-unwrapped
#     ;
# }
