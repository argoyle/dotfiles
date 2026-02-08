- Always follow the conventional commits format when commiting
- always git add all files before running pre-commit
- always unzip files to a temporary directory
- always run go generate ./... when changing a graphql schema
- if current branch is gitbutler/workspace, use but cli tool to create new feature branches, assign changes to branches (but rub)
  and commiting (but commit)
- it's always `but branch new` and not `bu branch create`
- always name goose migrations with a numeric prefix with current date and time following the YYYYMMDDHHmmss format
- Always add all files to git before running pre-commit since it stashes all unstaged files when running
- I use GNU versions of rm and cp which ask for confirmation on replace and remove.
- always use the latest versions of dependencies and docker images
- We don't use docker buildx but build-tools
- Always add unit tests when making changes, if possible
- Always explicitly specify the context when running `kubectl` commands using `--context <context>`. Check the project's `.buildtools.yaml` or `.envrc` for the expected k8s context. Never rely on the current default context — it may point to a different cluster (e.g., production instead of local). For local development, the context typically follows the pattern: `kind-<project-name>`

## GitButler Workflow (when on gitbutler/workspace branch)

When the current branch is `gitbutler/workspace`, use the `but` CLI instead of git.

- **NEVER use `git push`** when on the `gitbutler/workspace` branch. Use `but push <branch>` instead.
- **Create PRs using `but pr new <branch>`** when the remote is GitHub.
  - In non-interactive mode, must use `-m "title\n\nbody"`, `-t` (use commit message), or `-F <file>`

### Pre-Commit Analysis Workflow

1. **Gather workspace state** (run both in parallel):
   - `but status --json` - Get structured changes with CLI IDs
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

### Key Commands Reference

#### Inspection

| Command | Purpose |
|---------|---------|
| `but status --json` | Get workspace state with CLI IDs |
| `but branch list --json` | Get existing branches |
| `but diff` | Show all uncommitted diffs |
| `but diff <cliId>` | Show diff for a file, branch, stack, or commit |
| `but show <commit-or-branch>` | Show commit details or branch commits |
| `but show <branch> --verbose` | Show branch with full commit details and files |

#### Branching and Committing

| Command | Purpose |
|---------|---------|
| `but branch new <name>` | Create new branch |
| `but branch new --anchor <parent> <name>` | Create dependent branch (stacked on parent) |
| `but rub <cliId> <branch>` | Assign single change (by CLI ID) to branch |
| `but rub zz <branch>` | Assign ALL unassigned changes to branch |
| `but stage <file-or-hunk> <branch>` | Stage a file or hunk to a branch (alternative to rub) |
| `but commit --only -m "msg" <branch>` | Commit only assigned files to branch |
| `but commit -c --only -m "msg"` | Create new branch and commit assigned files |
| `but commit -p <cliId> -m "msg" <branch>` | Commit specific files/hunks only |
| `but commit empty --before <target>` | Insert blank placeholder commit before target |
| `but mark <branch>` | Auto-stage new changes to this branch |
| `but mark <commit>` | Auto-amend new changes into this commit |
| `but unmark` | Remove all marks |
| `but discard <cliId>` | Discard uncommitted changes for a file/hunk |

#### Editing Commits

| Command | Purpose |
|---------|---------|
| `but reword <commit-id> -m "msg"` | Edit a commit message |
| `but reword <branch-id> -m "name"` | Rename a branch |
| `but absorb` | Amend uncommitted changes into appropriate existing commits |
| `but absorb <cliId>` | Absorb a specific uncommitted file into its matching commit |
| `but absorb <branch>` | Absorb all changes staged to a specific branch |
| `but absorb --dry-run` | Show absorption plan without making changes |
| `but squash <branch>` | Squash all commits in branch into bottom-most |
| `but squash <commit1> <commit2>` | Squash first commit into second |
| `but squash <commit1>..<commit2>` | Squash commit range into last commit |
| `but move <commit> <target>` | Move commit before target (commit or branch) |
| `but move <commit> <target> --after` | Move commit after target |
| `but uncommit <commit>` | Uncommit changes back to unstaged area |
| `but pick <source> <target-branch>` | Cherry-pick from unapplied branch |

#### Server Interactions

| Command | Purpose |
|---------|---------|
| `but push <branch>` | Push branch to remote (use instead of `git push`) |
| `but pr new -m "title\n\nbody" <branch>` | Create PR with custom title and body |
| `but pr new -t <branch>` | Create PR using commit message as default content |
| `but merge <branch>` | Merge a branch into local target branch |

#### Operation History

| Command | Purpose |
|---------|---------|
| `but undo` | Undo the last operation |
| `but oplog` | View operation history |

### Rub Operations Matrix

`but rub <SOURCE> <TARGET>` combines two entities:

| SOURCE / TARGET | zz (unassigned) | Commit | Branch | Stack |
|----------------|-----------------|--------|--------|-------|
| File/Hunk | Unstage | Amend | Stage | Stage |
| Commit | Undo | Squash | Move | - |
| Branch (all) | Unstage all | Amend all | Reassign | Reassign |
| Unassigned (zz) | - | Amend all | Stage all | Stage all |

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

- `--json` / `-j` — JSON output on any command
- `--status-after` — Print workspace status after mutation commands
- `-C <path>` — Run as if started in a different directory
