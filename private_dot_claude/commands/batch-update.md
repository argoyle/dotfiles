Apply the same change across multiple repositories.

## Instructions

You are orchestrating a batch update across multiple git repos. The user will describe what change to make and which repos to target.

### Input

`$ARGUMENTS` should describe:
- The change to make (e.g., "bump Go to 1.24", "add pre-commit config", "update CLAUDE.md with new convention")
- The target repos (e.g., "all Frostmoln services", "all shiny services", "all Go repos under ~/Source")

If the arguments are unclear, ask for clarification.

### Workflow

1. **Identify target repos**: Based on the description, find the repos. Common patterns:
   - "Frostmoln services" → Go service dirs under `~/Source/Frostmoln/` (each is a separate git repo)
   - "shiny services" → Service dirs under `~/Source/shiny/` (single monorepo)
   - "all Go repos" → Find repos with `go.mod` under `~/Source/`

2. **Validate on one repo first**: Pick one representative repo and:
   - Make the change
   - Run any relevant checks (build, test, lint)
   - Show the user the diff
   - Get approval before continuing

3. **Apply to all repos**: For each remaining repo, launch a sub-agent to:
   - Apply the same change pattern
   - Run checks if applicable
   - Report success or failure
   Use parallel sub-agents where possible for speed.

4. **Track progress**: Use TaskCreate to track which repos are done, which failed, which are pending.

5. **Commit and ship**: After all repos are updated:
   - For GitButler workspace repos: use `but` CLI workflow (branch, commit, push, PR)
   - For regular git repos: commit, push, create PR
   - Ask user before committing — they may want to review first

6. **Report summary**: Show a table of all repos with status (success/failed/skipped) and PR URLs.

### Important Notes

- **Frostmoln repos** are hosted on Gitea (`git.sm.internal`). Use Gitea REST API for PRs, NOT `but pr`.
- **Shiny/Unbound repos** are hosted on GitLab. Use `git push` and GitLab MR flow.
- **Chezmoi-managed repos** use GitHub. Use `gh` or `but pr`.
- Always read each file before editing — don't assume identical structure across repos.
- If a repo has a CLAUDE.md, read it for repo-specific conventions before making changes.
