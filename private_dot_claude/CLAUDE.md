- Always follow the conventional commits format when commiting
- always git add all files before running pre-commit
- always unzip files to a temporary directory
- always run go generate ./... when changing a graphql schema
- if current branch is gitbutler/workspace, use but cli tool to create new feature branches, assign changes to branches (but rub)
  and commiting (but commit)
- it's always `but branch new` and not `bu branch create`
- it's always `but apply <branch>` and not `but branch apply`
- always name goose migrations with a numeric prefix with current date and time following the YYYYMMDDHHmmss format
- Always add all files to git before running pre-commit since it stashes all unstaged files when running
- I use GNU versions of rm and cp which ask for confirmation on replace and remove.
- always use the latest versions of dependencies and docker images
- We don't use docker buildx but build-tools
- Always add unit tests when making changes, if possible
- Always create a new branch for new work; never reuse merged branches
- Prefer existing Renovate branches for dependency updates — do not manually edit dependency files (`go.mod`, `package.json`, etc.) when Renovate has already created a branch
- Go: always return empty slices (`[]`), never nil slices — nil serializes to JSON `null` and crashes frontends
- Go: always handle errcheck — wrap `json.Encode`, `json.NewEncoder().Encode()`, and similar calls with error checks
- Go: use `go mod tidy`, not manual `go.mod`/`go.sum` edits
- Always explicitly specify the context when running `kubectl` commands using `--context <context>`. Check the project's `.buildtools.yaml` or `.envrc` for the expected k8s context. Never rely on the current default context — it may point to a different cluster (e.g., production instead of local). For local development, the context typically follows the pattern: `kind-<project-name>`

## Workflow Orchestration

### Plan Mode
- Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- If something goes sideways, STOP and re-plan immediately — don't keep pushing
- Use plan mode for verification steps, not just building
- Write detailed specs upfront to reduce ambiguity
- Pour energy into the plan so implementation can be done in one shot

### Subagent Strategy
- Use subagents liberally to keep main context window clean
- Offload research, exploration, and parallel analysis to subagents
- For complex problems, throw more compute at it via subagents
- One task per subagent for focused execution
- When spawning agents/subprocesses that need the `claude` binary, ALWAYS use `/opt/homebrew/bin/claude` (the stable symlink), NEVER the versioned Caskroom path (`/opt/homebrew/Caskroom/claude-code/<version>/claude`) which breaks on upgrades
- **File freshness after sub-agents**: After sub-agents modify files, always re-read the file before making further edits — sub-agent changes may have shifted line numbers or content

### Context Management
- Use subagents for exploration — keep the main context window focused on decision-making
- Delegate research and multi-file analysis to subagents rather than pulling large results into the main thread
- Return only summarized insights from subagents — avoid dumping raw tool output into the conversation

### Self-Improvement Loop
- After ANY correction from the user: update auto-memory or the relevant CLAUDE.md with the pattern
- Write rules for yourself that prevent the same mistake
- Ruthlessly iterate on these rules until mistake rate drops

### Verification Before Done
- Never mark a task complete without proving it works
- Before creating PRs: run the full lint and test suite if available
- Diff behavior between main and your changes when relevant
- Ask yourself: "Would a staff engineer approve this?"

### Demand Elegance (Balanced)
- For non-trivial changes: pause and ask "is there a more elegant way?"
- If a fix feels hacky: rethink and implement the elegant solution
- Skip this for simple, obvious fixes — don't over-engineer

### Autonomous Bug Fixing
- When given a bug report: just fix it — don't ask for hand-holding
- Point at logs, errors, failing tests — then resolve them
- Go fix failing CI tests without being told how
- **Before diagnosing**: gather actual evidence first (logs, error messages, versions, recent changes)
- **Form hypotheses, then verify** — never jump straight to code changes based on assumptions
- **List 3+ hypotheses** ranked by likelihood before committing to a fix — describe what evidence would confirm or eliminate each
- **Never add delays or workaround hacks** as a first attempt (e.g., `sleep`, retry loops, animation waits) — find the actual root cause first
- If the first fix attempt fails, STOP and re-examine evidence from scratch — don't iterate on a wrong diagnosis

## Core Principles

- **Simplicity First**: Make every change as simple as possible. Minimal code impact.
- **No Laziness**: Find root causes. No temporary fixes. Senior developer standards.
- **Minimal Impact**: Changes should only touch what's necessary. Avoid introducing bugs.

## Multi-Repo Batch Operations

When applying the same change across multiple repositories:

- **Validate on one repo first** before scaling to all — confirm the edit, build, and CI pass on a single repo, then apply the pattern to the rest
- **CI not triggering after push**: If the remote already has the same commit SHA, CI webhooks won't fire. Amend the commit (`git commit --amend --no-edit`) and force push to generate a new SHA
- **Use `Read` tool to verify file state** before applying `Edit` — files may have changed from parallel sub-agent work or previous batch operations
- **Track progress**: Use TaskCreate/TaskUpdate to track which repos are done, which need fixes, and which are pending CI
- **Avoid sed for multiline changes** — use Python, Go, or the Edit tool instead; sed multiline replacements are fragile and error-prone across different file formats

## Linear CLI (Issue Tracking)

Key patterns (for full command reference, see `~/.claude/linear-reference.md`):

- **Issue IDs** use the format `TEAM-123` (e.g., `ENG-456`)
- **Sort is required for `issue list`**: Always pass `--sort priority` (or `--sort manual`). Without it, the command fails with an error. Can also be set via `LINEAR_ISSUE_SORT` env var or `.linear.toml` config
- `linear issue start` creates a git branch named after the issue and sets state to "In Progress"
- `linear issue id` infers the issue from the current git branch name
- Most commands that accept `[issueId]` will auto-detect from the current branch if omitted
- Use `--no-interactive` on `create` commands for scripted/automated usage
- Use `--description-file <path>` for markdown descriptions (preferred over `-d` for multi-line)
- Global: `-w, --workspace <slug>` to target a specific workspace; `LINEAR_DEBUG=1` for stack traces

## GitButler Workflow (when on gitbutler/workspace branch)

When the current branch is `gitbutler/workspace`, use the `but` CLI instead of git.
For full command reference, see `~/.claude/gitbutler-reference.md`.

### Essential Rules
- **ALWAYS `but pull` before ANY branch operation** (`but rub`, `but commit`, `but absorb`, `but branch new`). Branches may have been merged upstream — pulling first removes integrated branches and prevents assigning changes to stale branches. This is non-negotiable.
- **Always pass `-C <repo-root>` BEFORE the subcommand** in every `but` command (e.g., `but -C /path status`, NOT `but status -C /path`)
- **NEVER use `git push`** when on the `gitbutler/workspace` branch. Use `but push <branch>` instead.
- **NEVER use `but pr` for Gitea remotes** — use Gitea REST API via curl instead
- **Create PRs using `but pr new <branch>`**:
  - **GitHub remotes**: Use `-m "title\n\nbody"` or `-F <file>`
  - **GitLab remotes**: Always use `-t` flag only
  - **Gitea remotes** (git.unbound.se, git.nl.cloud): Use Gitea REST API directly:
    ```bash
    curl -sk -X POST \
      -H "Authorization: token $GITEA_TOKEN" \
      -H "Content-Type: application/json" \
      -d '{"title":"PR title","head":"branch-name","base":"main"}' \
      "https://<host>/api/v1/repos/<owner>/<repo>/pulls"
    ```
    API endpoint for `git.unbound.se` is `gitea.unbound.se`. For `git.nl.cloud` it's `https://git.nl.cloud:8443`.

### Pre-Commit Analysis Workflow

1. **Pull latest from remote**: `but pull` — ensures merged branches are detected and removed before assigning changes
2. **Gather workspace state** (run both in parallel):
   - `but status --json` - Get structured changes with CLI IDs (check for `locked` fields — locked changes are tied to an existing branch)
   - `but branch list --json` - Get existing branches

3. **Analyze change content** (sample diffs to understand patterns):
   - Run `git diff HEAD -- <file>` on a few representative files
   - Identify common change patterns across the repository
   - Look for semantic themes (migrations, rotations, config updates)

4. **Group changes by content pattern**, not just location:
   - Example: "ProtonPass ID -> name migration (18 files)" - all files changing from ID-based to name-based ProtonPass references
   - Secondary grouping by directory if changes are unrelated

5. **Present change groups to user** with suggested branch names:
   - Identify existing branches that match the change type
   - Flag locked changes and indicate which branch they're locked to — suggest anchored branches when new changes depend on locked ones

6. **Ask user for confirmation** on grouping, branch names, and assignment

### Commit Workflow

1. **Pull latest from remote**: `but pull` — MUST run before any `rub`, `commit`, or `absorb` to remove integrated branches
2. **Create branches** if needed: `but branch new <name>` (or `--anchor <parent> <name>` for stacked/dependent)
   - If changes are locked to an existing branch, anchor new branches to it
3. **Assign changes using CLI IDs** (NOT file paths): `but rub <cliId> <branch>` or `but rub zz <branch>` for all
4. **Run pre-commit** (if `.pre-commit-config.yaml` exists): `git add -A && pre-commit run --all-files`
5. **Commit to branch**: `but commit --only -m "message" <branch>` (always use `--only`)
6. Follow conventional commits format
7. **Pull and resolve before pushing**: `but pull` then `but push <branch>`
   - If conflicts: `but resolve <commit>`, fix files, `but resolve finish`
