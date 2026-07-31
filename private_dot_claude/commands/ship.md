Ship the current GitButler branch: commit, push, and create a PR.

## Instructions

You are on a `gitbutler/workspace` branch. Follow the GitButler workflow from CLAUDE.md to ship changes.

### Steps

1. **Check status**: Run `but -C <repo-root> status --json` to see uncommitted changes and existing branches.

2. **Pre-commit** (if `.pre-commit-config.yaml` exists): Run `git add -A && pre-commit run --all-files`. Fix any issues.

3. **Commit**: Run:
   `but -C <repo-root> commit -m "<conventional commit message>" -b <branch>`
   - `-b <branch>` creates the branch if it doesn't exist.
   - All uncommitted changes are included by default. To split across branches, pass the file/hunk CLI IDs positionally: `... -b <branch> <cliId> <cliId>`, one commit per branch.
   - Re-run `but status` between commits — CLI IDs shift after every mutation.
   - Use conventional commits format. Infer the message from the diff content.

4. **Pull**: Run `but -C <repo-root> pull` to sync before pushing.

5. **Push**: Run `but -C <repo-root> push <branch>` for each branch with new commits.
   Prints `✓ Push completed successfully` and the pushed SHA.

6. **Create PR**: Run `but -C <repo-root> pr new <branch> -F <file>` for each pushed branch,
   writing the title (first line) and body (rest) to a temp file first — `-m` takes a single
   value and the shell does not expand `\n`.
   - For Gitea remotes, use the Gitea REST API instead (see CLAUDE.md).
   - Use the commit message as the PR title. Add a brief body summarizing the changes.

7. **Report**: Show the PR URL(s) when done.

### Notes

- Never use `but land` here — it bypasses PR review.
- If changes should be split across multiple branches, propose the grouping and ask the user to confirm before committing.
- If changes span multiple branches, ship all of them.
- The argument `$ARGUMENTS` can optionally specify a branch name to ship only that branch.
