{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    git-lfs
  ];
  home.file.".ssh/allowed_signers".text = "* ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDl7gQkCTPSNY5tMYWHlegVR1iO7NENN/2atndoPFj0Td3QLVlBzkFYSRhzTCinwy3UoG01p09Yt94Mwk17ZgpKQAj3fmki0EMlK8YRKeoieOEaIIbp1sMVUCGOUt1wGOiNkH8Fi759HdKpSabngLwYmTF1AFSH2SPAXY0+/Y+w3+Nf+Eu1IZmIQQ5g1o9kbpzvyNTRNBNZzHSrODzP3qY6DhOl+OKT1jA22Qa6gfCBiYNkhF11I0AkK0ln4TlFLAEjIPeZQwgmANwHRf9Gq7+i6jHtIHcwvID/ldRfYRFspavUZPJRWtajvZ7mVUaYDpBfWntdf50T9jY/UlXFY8FA33Eh3d0OUvDGTaW/p55q9I5AnLW5g0fgPiOSfjnGJYLPdGjVH9Kt8btLSlJfwscYgaCLkgq14u1lQ/ZtCmy1BxdLFYYxqQUkOdeX+XcHW4RF5hE1SZEjNhm7FMD3U3kCDRo7L9afqGRz2MPjvWYgIfwqpFcFqAuD2XKhKOxWvWjBc3S/c/Rm/sXKO0mExdB0ahVAWLpsjqM/gFB875rtm9CIegbP2Wltn6LPi2xTDVGs73jDfJznKl8uhxtFKMpiIDPT06bjMiG1KJ3df3hQOX7fXsWVnFwXTrgkgrG9C5EP8VRVV5u1bjPbOVtz6HRkRT83jx6t4nCYn+dc5A4uvQ== cardno:7127229";
  programs.git = {
    enable = true;
    delta.enable = true;
    userName = "Frank Hinek";
    userEmail = "frankhinek@users.noreply.github.com";
    aliases = {
      co = "checkout";
      count = "shortlog -sn";
      g = "grep --break --heading --line-number";
      gi = "grep --break --heading --line-number -i";
      changed = ''show --pretty="format:" --name-only'';
      fm = "fetch-merge";
      please = "push --force-with-lease";
      commit = "commit -s";
      commend = "commit -s --amend --no-edit";
      lt = "log --tags --decorate --simplify-by-decoration --oneline";
      unshallow = "fetch --prune --tags --unshallow";
    };
    extraConfig = {
      commit.gpgSign = true;
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      user.signingKey = "4B0D22C54A148CD7";
      lfs = {
        enable = true;
      };
      core = {
        editor = "nvim";
        compression = -1;
        autocrlf = "input";
        whitespace = "trailing-space,space-before-tab";
        precomposeunicode = true;
      };
      color = {
        diff = "auto";
        status = "auto";
        branch = "auto";
        ui = true;
      };
      advice = {
        addEmptyPathspec = false;
      };
      apply = {
        whitespace = "nowarn";
      };
      help = {
        autocorrect = 1;
      };
      grep = {
        extendRegexp = true;
        lineNumber = true;
      };
      push = {
        autoSetupRemote = true;
        default = "simple";
      };
      submodule = {
        fetchJobs = 4;
      };
      log = {
        showSignature = false;
      };
      format = {
        signOff = true;
      };
      rerere = {
        enabled = true;
      };
      pull = {
        ff = "only";
      };
      init = {
        defaultBranch = "main";
      };
    };
    ignores = lib.splitString "\n" (builtins.readFile ./gitignore_global);
  };
}