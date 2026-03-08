Ship the current GitButler branch: commit, push, and create a PR.

## Instructions

You are on a `gitbutler/workspace` branch. Follow the GitButler workflow from CLAUDE.md to ship changes.

### Steps

1. **Check status**: Run `but -C <repo-root> status --json` to see unassigned and branch-assigned changes.

2. **Pre-commit** (if `.pre-commit-config.yaml` exists): Run `git add -A && pre-commit run --all-files`. Fix any issues.

3. **Commit**: For each branch with uncommitted changes, run:
   `but -C <repo-root> commit --only -m "<conventional commit message>" <branch>`
   Use conventional commits format. Infer the message from the diff content.

4. **Pull**: Run `but -C <repo-root> pull` to sync before pushing.

5. **Push**: Run `but -C <repo-root> push <branch>` for each branch with new commits.

6. **Create PR**: Run `but -C <repo-root> pr new <branch> -m "<title>\n\n<body>"` for each pushed branch.
   - For Gitea remotes, use the Gitea REST API instead (see CLAUDE.md).
   - Use the commit message as the PR title. Add a brief body summarizing the changes.

7. **Report**: Show the PR URL(s) when done.

### Notes

- If there are unassigned changes, ask the user how to handle them (create branch, assign to existing, etc.) before proceeding.
- If changes span multiple branches, ship all of them.
- The argument `$ARGUMENTS` can optionally specify a branch name to ship only that branch.
