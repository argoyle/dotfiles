## General Rules

- Always follow conventional commits format when committing
- Always git add all files before running pre-commit (it stashes unstaged files)
- Always unzip files to a temporary directory
- Always run `go generate ./...` when changing a GraphQL schema
- Always name goose migrations with YYYYMMDDHHmmss prefix
- I use GNU versions of rm and cp which ask for confirmation on replace and remove
- Always use the latest versions of dependencies and docker images
- We don't use docker buildx but build-tools
- Always create a new branch for new work; never reuse merged branches
- Always explicitly specify `--context <context>` when running kubectl commands. Check `.buildtools.yaml` or `.envrc` for the expected context. Never rely on the default — it may point to production.
- Go: always return empty slices (`[]`), never nil slices — nil serializes to JSON `null`
- Go: always handle errcheck
- Go: use `go mod tidy`, not manual `go.mod`/`go.sum` edits

## Renovate

- Prefer existing Renovate branches for dependency updates — do not manually edit dependency files when Renovate has already created a branch
- When investigating Renovate upgrade problems, always `but apply` the Renovate branch first

## Workflow Orchestration

### Plan Mode
- Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- If something goes sideways, STOP and re-plan immediately
- Pour energy into the plan so implementation can be done in one shot

### Subagent Strategy
- Use subagents liberally to keep main context window clean
- One task per subagent for focused execution
- After sub-agents modify files, always re-read before making further edits

### Self-Improvement Loop
- After ANY correction from the user: update auto-memory or CLAUDE.md with the pattern

### Verification Before Done
- Never mark a task complete without proving it works
- Before creating PRs: run the full lint and test suite
- Ask yourself: "Would a staff engineer approve this?"

### Autonomous Bug Fixing
- When given a bug report: just fix it — don't ask for hand-holding
- Before diagnosing: gather actual evidence first (logs, errors, versions)
- Form hypotheses, then verify — never jump to code changes based on assumptions
- List 3+ hypotheses ranked by likelihood before committing to a fix
- Never add delays or workaround hacks as a first attempt — find the root cause
- If the first fix fails, STOP and re-examine from scratch

### Demand Elegance (Balanced)
- For non-trivial changes: pause and ask "is there a more elegant way?"
- Skip this for simple, obvious fixes — don't over-engineer

## Core Principles

- **Simplicity First**: Minimal code impact.
- **No Laziness**: Find root causes. No temporary fixes.
- **Minimal Impact**: Only touch what's necessary.

## Multi-Repo Batch Operations

- Validate on one repo first before scaling to all
- If CI doesn't trigger after push (same SHA): amend and force push
- Always Read files before Edit — parallel sub-agents may have changed them
- Track progress with TaskCreate/TaskUpdate
- Avoid sed for multiline changes — use Edit tool

## Linear CLI (Issue Tracking)

Key patterns (full reference: `~/.claude/linear-reference.md`):

- Issue IDs: `TEAM-123` format
- Sort is required for `issue list`: always pass `--sort priority`
- `linear issue start` creates a branch and sets state to "In Progress"
- `linear issue id` infers issue from current branch name
- Use `--no-interactive` on `create` for scripted usage
- Use `--description-file <path>` for markdown descriptions

## GitButler Workflow (when on gitbutler/workspace branch)

Use `but` CLI instead of git. Full reference: `~/.claude/gitbutler-reference.md`.

### Essential Rules
- **ALWAYS `but pull` before assigning changes or committing**. This is non-negotiable.
- **Always pass `-C <repo-root>` BEFORE the subcommand** (e.g., `but -C /path status`)
- **NEVER use `git push`** on gitbutler/workspace — use `but push <branch>`
- `but rub zz <branch>` stages all unassigned changes
- **NEVER use `but pr` for Gitea remotes** — use REST API instead
- **PR creation by remote type**:
  - **GitHub**: `but pr new <branch> -m "title\n\nbody"`
  - **GitLab**: `but pr new <branch> -t "title"`
  - **Gitea** (git.unbound.se, git.sm.internal): Gitea REST API via curl
    - `git.unbound.se` API: `gitea.unbound.se`
    - `git.sm.internal` API: `https://git.sm.internal:8443`
- **PR management**: `but pr auto-merge`, `but pr set-draft`, `but pr set-ready`

### Pre-Commit Analysis Workflow

1. `but pull` — sync and remove integrated branches
2. Gather state in parallel: `but status --json` + `but branch list --json`
3. Sample diffs to understand change patterns
4. Group changes by content pattern, not just location
5. Present groups with suggested branch names — flag locked changes
6. Ask user for confirmation before assigning

### Commit Workflow

1. `but pull`
2. `but branch new <name>` (or `--anchor <parent> <name>` for stacked)
3. `but rub <cliId> <branch>` or `but rub zz <branch>` for all
4. `git add -A && pre-commit run --all-files`
5. `but commit --only -m "message" <branch>`
   - `-c <branch>` to create+commit in one step (no `--only`)
   - `-p <cliId1>,<cliId2>` for partial commits
6. `but pull` then `but push <branch>`
   - Conflicts: `but resolve <commit>`, fix, `but resolve finish`
