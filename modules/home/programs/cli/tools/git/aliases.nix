_: {
  aliases = {
    a = "add";
  };

  shellAliases = {
    ga = "git add";
    gaa = "git add --all";
    gap = "git add --patch";

    gb = "git branch -v";
    gbd = "git branch -d";
    gbD = "git branch -D";
    gbr = "git branch --remote";

    gco = "git checkout";
    gcob = "git checkout -b";

    gc = "git commit -v";
    gca = "git commit -v --amend";
    gcam = "git commit -v --amend -m";
    gcm = "git commit -m";

    gd = "git diff";

    gf = "git fetch";
    gfa = "git fetch --all";
    gfap = "git fetch --all --prune";
    gfo = "git fetch origin";

    glg = "git log --graph --decorate --oneline --abbrev-commit";

    gpl = "git pull";
    gpld = "git pull --dry-run";
    gplo = "git pull origin";

    gp = "git push";
    gpf = "git push --force";
    gpo = "git push origin";

    gr = "git remote -v";

    gm = "git switch (git main-branch)";
    gw = "git switch";
    gwc = "git switch -c";

    gs = "git status -sb";
  };
}
