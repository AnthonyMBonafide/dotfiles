{ config, pkgs, ... }:

{
  # Fish shell abbreviations and aliases
  programs.fish.shellAbbrs = {
    src = "source ~/.config/fish/config.fish";
    gb = "go build ./... && go test -run=XXX_SHOULD_NEVER_MATCH_XXX ./...";
    gbt = "go test -run=XXX_SHOULD_NEVER_MATCH_XXX ./...";
    n = "nvim";
    ls = "eza";
    l = "eza -al --icons always -b --git";
    lt = "eza -al --icons always -b --git --total-size -T";
    cd = "z";
    ".." = "z ..";
    pms = "podman machine start";

    # Git
    g = "git";
    gf = "git fetch --all";
    grom = "git rebase origin/main";
    gfrom = "git fetch --all && git rebase origin/main";
    gp = "git push origin HEAD";
    gpwl = "git push origin HEAD --force-with-lease";
    ga = "git add .";
    gc = "git commit -s -S";
    gca = "git commit -s -S -a -u";
    gs = "git status";
    gl = "git log";
    gd = "git diff";
    gwta = "gf && git worktreea";
    gcpe = "git commit -s -S -a -u && git push origin HEAD";
    gcpef = "git commit -s -S -a -u && git push origin HEAD --force-with-lease";
    gwtr = "git worktree remove";
    gwtrf = "git worktree remove --force";

    # Nix
    not = "nh os test";
    nob = "nh os build";
    nos = "nh os switch";
  };
}
