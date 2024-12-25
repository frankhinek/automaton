{ pkgs, ... }:
{
  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  security.sudo.extraRules = [
    {
      users = [ "frank" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.frank = {
    isNormalUser = true;
    description = "frank";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDl7gQkCTPSNY5tMYWHlegVR1iO7NENN/2atndoPFj0Td3QLVlBzkFYSRhzTCinwy3UoG01p09Yt94Mwk17ZgpKQAj3fmki0EMlK8YRKeoieOEaIIbp1sMVUCGOUt1wGOiNkH8Fi759HdKpSabngLwYmTF1AFSH2SPAXY0+/Y+w3+Nf+Eu1IZmIQQ5g1o9kbpzvyNTRNBNZzHSrODzP3qY6DhOl+OKT1jA22Qa6gfCBiYNkhF11I0AkK0ln4TlFLAEjIPeZQwgmANwHRf9Gq7+i6jHtIHcwvID/ldRfYRFspavUZPJRWtajvZ7mVUaYDpBfWntdf50T9jY/UlXFY8FA33Eh3d0OUvDGTaW/p55q9I5AnLW5g0fgPiOSfjnGJYLPdGjVH9Kt8btLSlJfwscYgaCLkgq14u1lQ/ZtCmy1BxdLFYYxqQUkOdeX+XcHW4RF5hE1SZEjNhm7FMD3U3kCDRo7L9afqGRz2MPjvWYgIfwqpFcFqAuD2XKhKOxWvWjBc3S/c/Rm/sXKO0mExdB0ahVAWLpsjqM/gFB875rtm9CIegbP2Wltn6LPi2xTDVGs73jDfJznKl8uhxtFKMpiIDPT06bjMiG1KJ3df3hQOX7fXsWVnFwXTrgkgrG9C5EP8VRVV5u1bjPbOVtz6HRkRT83jx6t4nCYn+dc5A4uvQ== cardno:7127229"
    ];
    # packages = with pkgs; [ ];
  };

  nixpkgs.config = {
    # Allow installation of packages that do not comply with the Free
    # Software Foundation's (FSF) definition of free software.
    allowUnfree = true;
  };

nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      auto-optimise-store = true;
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-users = [
        "root"
        "frank"
        "@wheel"
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  environment.systemPackages = with pkgs; [
    cachix
    coreutils
    curl
    git
    jq
    unzip
    wget
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.fish.enable = true;

  services.openssh.enable = true;
  services.cron.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      domain = true;
      addresses = true;
    };
  };
}