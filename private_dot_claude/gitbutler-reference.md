# GitButler CLI - Full Command Reference

## Inspection

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

## Branching and Committing

| Command | Purpose |
|---------|---------|
| `but branch new <name>` | Create new branch |
| `but branch new --anchor <parent> <name>` | Create dependent branch (stacked on parent) |
| `but rub <cliId> <branch>` | Assign single change (by CLI ID) to branch |
| `but rub zz <branch>` | Assign ALL unassigned changes to branch |
| `but stage` | Interactive TUI for selecting files and hunks to stage |
| `but stage <file-or-hunk> <branch>` | Stage a file or hunk to a branch (alternative to rub) |
| `but commit --only -m "msg" <branch>` | Commit only assigned files to branch |
| `but commit -c <name> -m "msg"` | Create new branch and commit (if name matches existing branch, uses that) |
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

## Editing Commits

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

## Conflict Resolution

| Command | Purpose |
|---------|---------|
| `but resolve <commit>` | Enter resolution mode for a conflicted commit |
| `but resolve status` | Show remaining conflicted files |
| `but resolve finish` | Finalize resolution and return to workspace |
| `but resolve cancel` | Cancel resolution and return to workspace |

## Server Interactions

| Command | Purpose |
|---------|---------|
| `but push <branch>` | Push branch to remote (use instead of `git push`) |
| `but push` | Push all branches with unpushed commits (non-interactive) |
| `but push -d <branch>` | Dry-run: show what would be pushed |
| `but push -f <branch>` | Force push even if not fast-forward |
| `but push -r <branch>` | Run pre-push hooks |
| `but pull --check` | Check if branches can cleanly merge without updating |
| `but pr new -m "title\n\nbody" <branch>` | Create PR with custom title and body (GitHub only) |
| `but pr new -F <file> <branch>` | Read PR title/body from file (first line = title, rest = body) |
| `but pr new -d <branch>` | Create PR as draft |
| `but pr new -t <branch>` | Create PR using default content from commits (required for GitLab) |
| `but pr auto-merge <branch>` | Enable/disable auto-merge on a PR |
| `but pr set-draft <branch>` | Set existing PR as draft |
| `but pr set-ready <branch>` | Set existing PR as ready for review |
| `but pr template` | Select PR description template from repo |
| `but merge <branch>` | Merge a branch into local target branch |

## Operation History

| Command | Purpose |
|---------|---------|
| `but undo` | Undo the last operation |
| `but oplog` | View operation history |

## Other

| Command | Purpose |
|---------|---------|
| `but gui` / `but .` | Open the GitButler GUI for current project |
| `but setup` | Set up a GitButler project from a git repo |
| `but setup --init` | Initialize a new git repo and set up GitButler |
| `but teardown` | Exit GitButler mode, return to normal Git workflow |
| `but stack <branch> <target>` | Move existing branch on top of another to stack them |
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

## Rub Operations Matrix

`but rub <SOURCE> <TARGET>` combines two entities:

| SOURCE / TARGET | zz (unassigned) | Commit | Branch | Stack |
|----------------|-----------------|--------|--------|-------|
| File/Hunk | Unstage | Amend | Stage | Stage |
| Commit | Undo | Squash | Move | - |
| Branch (all) | Unstage all | Amend all | Reassign | Reassign |
| Stack (all) | Unstage all | - | Reassign | Reassign |
| Unassigned (zz) | - | Amend all | Stage all | Stage all |
| File-in-Commit | Uncommit | Move | Uncommit to | - |

## CLI ID Format

CLI IDs from `but status` are short codes like `g0`, `h0`, `i1`, etc.
- First character: letter (a-z)
- Second character: digit (0-9)
- Special: `zz` refers to ALL unassigned changes
- Use these IDs in `but rub`, `but stage`, `but discard`, etc.

## Global Options

- `-C <path>` — **Required**: Always pass this to target the correct repository (e.g., `but -C /path/to/repo <command>`)
- `--json` / `-j` — JSON output on any command
- `--status-after` — Print workspace status after mutation commands
