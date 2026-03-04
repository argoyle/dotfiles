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
- If the first fix attempt fails, STOP and re-examine evidence from scratch — don't iterate on a wrong diagnosis

## Core Principles

- **Simplicity First**: Make every change as simple as possible. Minimal code impact.
- **No Laziness**: Find root causes. No temporary fixes. Senior developer standards.
- **Minimal Impact**: Changes should only touch what's necessary. Avoid introducing bugs.

## Linear CLI (Issue Tracking)

Use the `linear` CLI (v1.10.0) for managing Linear issues, projects, and initiatives from the terminal.

### Authentication

| Command | Purpose |
|---------|---------|
| `linear auth login` | Add a workspace credential |
| `linear auth logout [workspace]` | Remove a workspace credential |
| `linear auth list` | List configured workspaces |
| `linear auth default [workspace]` | Set the default workspace |
| `linear auth whoami` | Print info about authenticated user |
| `linear auth token` | Print the configured API token |

### Issues

| Command | Alias | Purpose |
|---------|-------|---------|
| `linear issue list` | `linear i list` | List your issues (default: unstarted state) |
| `linear issue list -s started` | | List in-progress issues |
| `linear issue list --all-states` | | List issues across all states |
| `linear issue list -A` | | List issues for all assignees |
| `linear issue list -U` | | List unassigned issues |
| `linear issue list --project <name>` | | Filter by project |
| `linear issue list --team <key>` | | Filter by team |
| `linear issue view [issueId]` | `linear i v` | View issue details |
| `linear issue view [issueId] -j` | | Output issue as JSON |
| `linear issue view [issueId] -w` | | Open issue in browser |
| `linear issue create -t "title" -d "desc"` | | Create an issue |
| `linear issue create --team <key> -l <label>` | | Create with team and label |
| `linear issue create --start` | | Create and immediately start |
| `linear issue update [issueId] -s <state>` | | Update issue state |
| `linear issue update [issueId] -a self` | | Assign issue to yourself |
| `linear issue start [issueId]` | | Start working on issue (creates git branch) |
| `linear issue start [issueId] -b <branch>` | | Start with custom branch name |
| `linear issue id` | | Print issue ID from current git branch |
| `linear issue url [issueId]` | | Print the issue URL |
| `linear issue delete [issueId]` | `linear i d` | Delete an issue |

### Issue Comments & Relations

| Command | Purpose |
|---------|---------|
| `linear issue comment add [issueId]` | Add a comment to an issue |
| `linear issue comment list [issueId]` | List comments on an issue |
| `linear issue comment update <commentId>` | Update an existing comment |
| `linear issue relation add <id> <type> <relatedId>` | Add relation between issues |
| `linear issue relation list [issueId]` | List relations for an issue |
| `linear issue attach <issueId> <filepath>` | Attach a file to an issue |

### Pull Requests (GitHub)

| Command | Purpose |
|---------|---------|
| `linear issue pr [issueId]` | Create GitHub PR with issue details |
| `linear issue pr [issueId] --draft` | Create as draft PR |
| `linear issue pr [issueId] --base <branch>` | Specify target branch |
| `linear issue pr [issueId] -t "title"` | Custom PR title (issue ID prefixed) |

### Projects & Initiatives

| Command | Alias | Purpose |
|---------|-------|---------|
| `linear project list` | `linear p list` | List projects |
| `linear project view <id>` | `linear p v` | View project details |
| `linear project create` | | Create a new project |
| `linear project-update create <projectId>` | `linear pu c` | Create project status update |
| `linear project-update list <projectId>` | `linear pu l` | List project status updates |
| `linear milestone list` | `linear m list` | List milestones for a project |
| `linear milestone create` | | Create a milestone |
| `linear initiative list` | `linear init list` | List initiatives |
| `linear initiative view <id>` | `linear init v` | View initiative details |
| `linear initiative create` | | Create a new initiative |

### Teams, Labels & Documents

| Command | Purpose |
|---------|---------|
| `linear team list` | List teams |
| `linear team members [teamKey]` | List team members |
| `linear label list` | List issue labels |
| `linear label create` | Create a new label |
| `linear document list` | List documents |
| `linear document view <id>` | View document content |
| `linear document create` | Create a new document |
| `linear document update <id>` | Update a document |

### Raw API & Config

| Command | Purpose |
|---------|---------|
| `linear api <query>` | Make a raw GraphQL API request |
| `linear api <query> --variable key=value` | GraphQL with variables |
| `linear api <query> --paginate` | Auto-paginate a connection field |
| `linear config` | Interactively generate `.linear.toml` config |
| `linear completions` | Generate shell completions |

### Global Options

- `-w, --workspace <slug>` — Target a specific workspace
- `LINEAR_DEBUG=1` — Show full error details with stack traces

### Key Patterns

- **Issue IDs** use the format `TEAM-123` (e.g., `ENG-456`)
- `linear issue start` creates a git branch named after the issue and sets state to "In Progress"
- `linear issue id` infers the issue from the current git branch name
- Most commands that accept `[issueId]` will auto-detect from the current branch if omitted
- Use `--no-interactive` on `create` commands for scripted/automated usage
- Use `--description-file <path>` for markdown descriptions (preferred over `-d` for multi-line)

## GitButler Workflow (when on gitbutler/workspace branch)

When the current branch is `gitbutler/workspace`, use the `but` CLI instead of git.

- **Always pass `-C <repo-root>`** to every `but` command (e.g., `but -C /path/to/repo status`). This ensures the command targets the correct repository without relying on the current working directory. All examples below omit `-C` for brevity, but it must always be included.
- **NEVER use `git push`** when on the `gitbutler/workspace` branch. Use `but push <branch>` instead.
- **NEVER use `but pr` for Gitea remotes** — it will fail. Always use the Gitea REST API via curl.
- **Create PRs using `but pr new <branch>`**:
  - **GitHub remotes**: Use `-m "title\n\nbody"` or `-F <file>` to set a custom title and body
  - **GitLab remotes**: Always use `-t` flag only (`but pr new -t <branch>`) — do not try to set a PR title or body
  - **Gitea remotes** (git.unbound.se, git.nl.cloud): `but pr` does NOT support Gitea. Use the Gitea REST API directly:
    ```bash
    curl -sk -X POST \
      -H "Authorization: token $GITEA_TOKEN" \
      -H "Content-Type: application/json" \
      -d '{"title":"PR title","head":"branch-name","base":"main"}' \
      "https://<host>/api/v1/repos/<owner>/<repo>/pulls"
    ```
    Detect Gitea remotes by checking `git remote -v` for `git.unbound.se` or `git.nl.cloud`.
    **Note**: The HTTPS API endpoint for `git.unbound.se` repos is `gitea.unbound.se` (e.g., `https://gitea.unbound.se/api/v1/repos/...`).
    **Note**: The HTTPS API endpoint for `git.nl.cloud` repos is `https://git.nl.cloud:8443` (e.g., `https://git.nl.cloud:8443/api/v1/repos/...`).

### Pre-Commit Analysis Workflow

1. **Gather workspace state** (run both in parallel):
   - `but status --json` - Get structured changes with CLI IDs (check for `locked` fields — locked changes are tied to an existing branch)
   - `but branch list --json` - Get existing branches

2. **Analyze change content** (sample diffs to understand patterns):
   - Run `git diff HEAD -- <file>` on a few representative files
   - Identify common change patterns across the repository
   - Look for semantic themes (migrations, rotations, config updates)

3. **Group changes by content pattern**, not just location:
   - Example: "ProtonPass ID -> name migration (18 files)" - all files changing from ID-based to name-based ProtonPass references
   - Example: "SSH key updates (4 files)" - all SSH key related changes
   - Example: "Envrc cleanup (3 files)" - environment configuration standardization
   - Secondary grouping by directory if changes are unrelated

4. **Present change groups to user** with suggested branch names:
   - Example: "ProtonPass name migration (18 files): `protonpass-name-migration`"
   - Example: "Brewfile updates (1 file): `brewfile-update`"
   - Identify existing branches that match the change type
   - Flag locked changes and indicate which branch they're locked to — suggest anchored branches when new changes depend on locked ones

5. **Ask user for confirmation** on:
   - How to group the changes (accept suggestions or regroup)
   - Branch names (suggest but allow override)
   - Assignment of changes to existing vs new branches

### Commit Workflow

1. **Pull latest from remote**: `but pull`
   - Always do this before creating new branches or committing to existing ones
   - This syncs with upstream and removes branches that have been merged
2. **Create branches** if needed: `but branch new <name>`
   - For dependent/stacked branches: `but branch new --anchor <parent> <name>`
   - **If any changes are locked to an existing branch**, create the new branch as anchored to that branch (e.g., `but branch new --anchor <locked-branch> <name>`). Locked changes indicate a dependency on commits in the existing branch.
3. **Assign changes using CLI IDs** (NOT file paths):
   - Single file: `but rub <cliId> <branch>` (e.g., `but rub g0 goodfeed-infra`)
   - All unassigned: `but rub zz <branch>` (when all changes go to one branch)
4. **Run pre-commit** (if `.pre-commit-config.yaml` exists in repo):
   - Stage all files first: `git add -A`
   - Run: `pre-commit run --all-files`
   - Fix any issues before proceeding
5. **Commit to branch**: `but commit --only -m "message" <branch>`
   - **IMPORTANT**: Always use `--only` flag to commit only the assigned files
   - Without `--only`, all staged files will be committed regardless of branch assignment
6. Follow conventional commits format
7. **Pull and resolve before pushing**: `but pull` again before `but push <branch>`
   - Always pull to rebase on top of any new upstream changes before pushing
   - If conflicts arise, resolve them with `but resolve <commit>`, fix files, then `but resolve finish`
   - Only push after a clean pull with no conflicts

### Key Commands Reference

#### Inspection

| Command | Purpose |
|---------|---------|
| `but status --json` | Get workspace state with CLI IDs |
| `but status -f` | Show status including committed files |
| `but status -v` | Verbose output with commit author and timestamp |
| `but status -u` | Show detailed upstream commits not yet integrated |
| `but status -r` | Force sync of PRs from forge before showing status |
| `but status --no-hint` | Disable command hints at end of output |
| `but branch list --json` | Get existing branches |
| `but diff` | Show all uncommitted diffs |
| `but diff <cliId>` | Show diff for a file, branch, stack, or commit |
| `but diff --tui` | Open interactive TUI diff viewer |
| `but show <commit-or-branch>` | Show commit details or branch commits |
| `but show <branch> --verbose` | Show branch with full commit details and files |

#### Branching and Committing

| Command | Purpose |
|---------|---------|
| `but branch new <name>` | Create new branch |
| `but branch new --anchor <parent> <name>` | Create dependent branch (stacked on parent) |
| `but rub <cliId> <branch>` | Assign single change (by CLI ID) to branch |
| `but rub zz <branch>` | Assign ALL unassigned changes to branch |
| `but stage` | Interactive TUI for selecting files and hunks to stage |
| `but stage <file-or-hunk> <branch>` | Stage a file or hunk to a branch (alternative to rub) |
| `but commit --only -m "msg" <branch>` | Commit only assigned files to branch |
| `but commit -c --only -m "msg"` | Create new branch and commit assigned files |
| `but commit -p <cliId> -m "msg" <branch>` | Commit specific files/hunks only |
| `but commit -i -m "msg" <branch>` | AI-generated commit message (optional summary after `--ai=`) |
| `but commit -n <branch>` | Bypass pre-commit hooks |
| `but commit --message-file <file> <branch>` | Read commit message from file |
| `but commit empty --before <target>` | Insert blank placeholder commit before target |
| `but commit empty --after <target>` | Insert blank placeholder commit after target |
| `but mark <branch>` | Auto-stage new changes to this branch |
| `but mark <commit>` | Auto-amend new changes into this commit |
| `but mark -d <target>` | Delete a specific mark |
| `but unmark` | Remove all marks |
| `but apply <branch>` | Apply (enable) an unapplied branch |
| `but unapply <branch>` | Unapply (stash) a branch from workspace |
| `but discard <cliId>` | Discard uncommitted changes for a file/hunk |
| `but branch delete <branch>` | Delete a branch |

#### Editing Commits

| Command | Purpose |
|---------|---------|
| `but reword <commit-id> -m "msg"` | Edit a commit message |
| `but reword <branch-id> -m "name"` | Rename a branch |
| `but absorb` | Amend uncommitted changes into appropriate existing commits |
| `but absorb <cliId>` | Absorb a specific uncommitted file into its matching commit |
| `but absorb <branch>` | Absorb all changes staged to a specific branch |
| `but absorb --dry-run` | Show absorption plan without making changes |
| `but absorb --new` | Create new commits instead of amending existing ones |
| `but amend <file> <commit>` | Amend file into commit (shorthand for `but rub <file> <commit>`) |
| `but squash <branch>` | Squash all commits in branch into bottom-most |
| `but squash <commit1> <commit2>` | Squash first commit into second |
| `but squash <commit1>..<commit2>` | Squash commit range into last commit |
| `but move <commit> <target>` | Move commit before target (commit or branch) |
| `but move <commit> <target> --after` | Move commit after target |
| `but uncommit <commit>` | Uncommit changes back to unstaged area |
| `but pick <source> <target-branch>` | Cherry-pick from unapplied branch |

#### Conflict Resolution

| Command | Purpose |
|---------|---------|
| `but resolve <commit>` | Enter resolution mode for a conflicted commit |
| `but resolve status` | Show remaining conflicted files |
| `but resolve finish` | Finalize resolution and return to workspace |
| `but resolve cancel` | Cancel resolution and return to workspace |

#### Server Interactions

| Command | Purpose |
|---------|---------|
| `but push <branch>` | Push branch to remote (use instead of `git push`) |
| `but push` | Push all branches with unpushed commits (non-interactive) |
| `but push -d <branch>` | Dry-run: show what would be pushed |
| `but push -f <branch>` | Force push even if not fast-forward |
| `but push -r <branch>` | Run pre-push hooks |
| `but pull --check` | Check if branches can cleanly merge without updating |
| `but pr new -m "title\n\nbody" <branch>` | Create PR with custom title and body (GitHub only) |
| `but pr new -d <branch>` | Create PR as draft |
| `but pr new -t <branch>` | Create PR using default content from commits (required for GitLab) |
| `but pr auto-merge <branch>` | Enable/disable auto-merge on a PR |
| `but pr set-draft <branch>` | Set existing PR as draft |
| `but pr set-ready <branch>` | Set existing PR as ready for review |
| `but pr template` | Select PR description template from repo |
| `but merge <branch>` | Merge a branch into local target branch |

#### Operation History

| Command | Purpose |
|---------|---------|
| `but undo` | Undo the last operation |
| `but oplog` | View operation history |

#### Other

| Command | Purpose |
|---------|---------|
| `but gui` / `but .` | Open the GitButler GUI for current project |
| `but setup` | Set up a GitButler project from a git repo |
| `but setup --init` | Initialize a new git repo and set up GitButler |
| `but teardown` | Exit GitButler mode, return to normal Git workflow |
| `but config` | View configuration overview (user, forge, target, metrics, ui) |
| `but config ui set tui true` | Enable TUI mode for diff by default |
| `but alias add <name> <command>` | Create command shortcut |
| `but alias remove <name>` | Remove a command shortcut |
| `but alias list` | List all aliases |
| `but skill install` | Install GitButler AI skill files for coding agents |
| `but skill check` | Check if installed skills are up to date |
| `but update check` | Check for new CLI version |
| `but update install` | Install or update the GitButler desktop app |
| `but update suppress` | Suppress update notifications temporarily |

### Rub Operations Matrix

`but rub <SOURCE> <TARGET>` combines two entities:

| SOURCE / TARGET | zz (unassigned) | Commit | Branch | Stack |
|----------------|-----------------|--------|--------|-------|
| File/Hunk | Unstage | Amend | Stage | Stage |
| Commit | Undo | Squash | Move | - |
| Branch (all) | Unstage all | Amend all | Reassign | Reassign |
| Stack (all) | Unstage all | - | Reassign | Reassign |
| Unassigned (zz) | - | Amend all | Stage all | Stage all |
| File-in-Commit | Uncommit | Move | Uncommit to | - |

### CLI ID Format

CLI IDs from `but status` are short codes like `g0`, `h0`, `i1`, etc.
- First character: letter (a-z)
- Second character: digit (0-9)
- Special: `zz` refers to ALL unassigned changes
- Use these IDs in `but rub`, `but stage`, `but discard`, etc.

### Optimization: Bulk Assignment

When all unassigned changes should go to a single branch:
- Use `but rub zz <branch>` to assign everything at once
- This is faster than assigning files individually

### Global Options

- `-C <path>` — **Required**: Always pass this to target the correct repository (e.g., `but -C /path/to/repo <command>`)
- `--json` / `-j` — JSON output on any command
- `--status-after` — Print workspace status after mutation commands
