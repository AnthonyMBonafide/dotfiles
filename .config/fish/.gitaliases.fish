set DEFAULT_BRANCH main
set DEFAULT_ORIGN origin

abbr g git
abbr gf git fetch --all
abbr grom git rebase $DEFAULT_ORIGN/$DEFAULT_BRANCH
abbr gfrom "git fetch --all && git rebase $DEFAULT_ORIGN/$DEFAULT_BRANCH"
abbr gp git push origin HEAD
abbr gpwl git push origin HEAD --force-with-lease
abbr ga git add .
abbr gc git commit -s -S
abbr gca git commit -s -S -a -u
abbr gs git status
abbr gl git log
abbr gd git diff
abbr gwta "gf && git worktreea"
abbr gcpe "git commit -s -S -a -u && git push origin HEAD"
abbr gcpef "git commit -s -S -a -u && git push origin HEAD --force-with-lease"
abbr gwtr git worktree remove
abbr gwtrf git worktree remove --force

# JJ aliases
abbr jbc jj bookmark create -r@ AnthonyMBonafide/
abbr jbla jj bookmark list -a
abbr jbl jj bookmark list
abbr jgp jj git push -r@ --allow-new
abbr jbm jj bookmark move -f@- -t@
abbr jrm jj rebase -s @ -d main
abbr jgf jj git fetch
abbr jd jj desc
