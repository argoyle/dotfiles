# GitButler CLI - Full Command Reference

> Reference verified against `but 0.20.1`.
>
> **Output format (breaking change in 0.20):** the old `--json` / `-j` flags were
> **removed**. Use `--format <FORMAT>` instead (env `BUT_OUTPUT_FORMAT`), where
> `FORMAT` is one of:
> - `human` — verbose, for terminal reading (default on a TTY)
> - `agent` — human-readable text tuned for AI coding agents
> - `shell` — assigns the major result to shell variables for reuse (default when piped/redirected)
> - `json` — detailed JSON for tool consumption (**replaces `--json`**)
> - `none` — suppress output (like `/dev/null`)
>
> So `but status --json` becomes `but status --format json`.
>
> Most mutation commands still accept `--status-after` to also print workspace status
> after the command (in JSON mode, wraps `{"result": ..., "status": ...}`).

## Inspection

| Command | Purpose |
|---------|---------|
| `but status --format json` | Get workspace state with CLI IDs (was `--json`) |
| `but status -f` | Show status including committed files |
| `but status -v` | Verbose output with commit author and timestamp |
| `but status -u` | Show detailed upstream commits not yet integrated |
| `but status -r` | Force sync of PRs from forge before showing status |
| `but status --no-hint` | Disable command hints at end of output |
| `but branch list --format json` | Get existing branches (was `--json`) |
| `but diff` | Show all uncommitted diffs |
| `but diff <cliId>` | Show diff for a file, branch, stack, commit, or file-in-commit |
| `but diff --tui` | Open interactive TUI diff viewer |
| `but diff --no-tui` | Disable TUI diff viewer (overrides `but.ui.tui` config) |
| `but show <commit-or-branch>` | Show commit details or branch commits |
| `but show <branch> --verbose` | Show branch with full commit details and files |

## Branching and Committing

| Command | Purpose |
|---------|---------|
| `but branch new <name>` | Create new branch |
| `but branch new --anchor <parent> <name>` | Create dependent branch (stacked on parent) |
| `but branch update <branch>` (alias `but branch -u`) | **New**: integrate the remote counterpart into your local branch (resolve divergence) |
| `but branch update -s <strategy> <branch>` | Pick integration strategy: `pull-rebase` (default), `smart-squash`, `merge`, `pick-remote` |
| `but branch update --dry-run <branch>` | Preview the resulting branch state (`-v` adds divergence detail; `-i` opens the integration script in an editor) |
| `but rub <cliId> <branch>` | Assign single change (by CLI ID) to branch |
| `but rub zz <branch>` | Assign ALL unassigned changes to branch |
| `but stage` | Interactive TUI for selecting files and hunks to stage |
| `but stage -b <branch>` | Interactive TUI staging to a specific branch |
| `but stage <file-or-hunk> <branch>` | Stage a file or hunk to a branch (alternative to rub) |
| `but commit --only -m "msg" <branch>` (alias `-o`) | Commit only assigned files to branch |
| `but commit -c <name> -m "msg"` | Create new branch and commit (if name matches existing branch, uses that) |
| `but commit -p <cliId>[,<cliId>...] -m "msg" <branch>` | Commit specific files/hunks (`-p` repeatable or comma-sep) |
| `but commit -i -m "msg" <branch>` | AI-generated commit message (optional instructions via `--ai="..."`) |
| `but commit -n <branch>` (alias `--no-hooks`) | Bypass pre-commit hooks |
| `but commit -a <branch>` | No-op compatibility flag for `git commit -a` |
| `but commit --message-file <file> <branch>` | Read commit message from file |
| `but commit --diff <branch>` | Always show diff in editor (regardless of size) |
| `but commit --no-diff <branch>` | Never show diff in editor |
| `but commit empty --before <target>` | Insert blank placeholder commit before target |
| `but commit empty --after <target>` | Insert blank placeholder commit after target |
| `but mark <branch>` | Auto-stage new changes to this branch |
| `but mark <commit>` | Auto-amend new changes into this commit |
| `but mark -d <target>` | Delete a specific mark |
| `but unmark` | Remove all marks |
| `but apply <branch>` | Apply (enable) an unapplied branch |
| `but unapply <branch>` | Unapply (stash) a branch from workspace |
| `but unapply -f <branch>` | Force unapply without confirmation |
| `but discard <cliId>` | Discard uncommitted changes for a file/hunk |
| `but branch delete <branch>` (alias `-d`) | Delete a branch |
| `but branch show <branch>` | Show commits ahead of base for a branch |

## Editing Commits

| Command | Purpose |
|---------|---------|
| `but reword <commit-id> -m "msg"` | Edit a commit message |
| `but reword <commit-id> -f` | Reformat existing message to 72-char wrap (no editor) |
| `but reword <commit-id> --diff` / `--no-diff` | Force show / hide diff inside editor |
| `but reword <branch-id> -m "name"` | Rename a branch |
| `but absorb` | Amend uncommitted changes into appropriate existing commits |
| `but absorb <cliId>` | Absorb a specific uncommitted file into its matching commit |
| `but absorb <branch>` | Absorb all changes staged to a specific branch |
| `but absorb --dry-run` | Show absorption plan without making changes |
| `but amend <file> <commit>` | Amend file into commit (shorthand for `but rub <file> <commit>`) |
| `but squash <branch>` | Squash all commits in branch into bottom-most |
| `but squash <commit1> <commit2>` | Squash first commit into second |
| `but squash <commit1>..<commit2>` | Squash commit range into last commit |
| `but squash -d <commits...>` | Drop source commit messages, keep only target's |
| `but squash -m "msg" <commits...>` | Provide a fresh message for the squashed commit |
| `but squash -i <commits...>` / `-i="hint"` | AI-generated squash message (optional hint) |
| `but move <commit> <target>` | Move commit before target (commit or branch) |
| `but move <commit> <target> --after` (alias `-a`) | Move commit after target |
| `but uncommit <commit>` | Uncommit changes back to unstaged area |
| `but uncommit -d <commit>` | Discard committed changes entirely (no return to unassigned) |
| `but pick <source> <target-branch>` | Cherry-pick from unapplied branch |

## Conflict Resolution

| Command | Purpose |
|---------|---------|
| `but resolve <commit>` | Enter resolution mode for a conflicted commit |
| `but resolve status` | Show remaining conflicted files |
| `but resolve finish` | Finalize resolution and return to workspace |
| `but resolve cancel` | Cancel resolution and return to workspace |

## Server Interactions

> `but mr` is an alias for `but pr` (use whichever reads better for GitHub PRs vs GitLab MRs).

| Command | Purpose |
|---------|---------|
| `but push <branch>` | Push branch to remote (use instead of `git push`) |
| `but push` | Push all branches with unpushed commits (non-interactive) |
| `but push -d <branch>` | Dry-run: show what would be pushed |
| `but push -f <branch>` (alias `--with-force`) | Force push even if not fast-forward |
| `but push -s <branch>` | Skip force-push protection checks |
| `but push --no-hooks <branch>` (alias `--no-verify`) | Bypass pre-push hooks |
| `but pull` | Update all applied branches to be up to date with the target branch |
| `but pull --check` (alias `-c`) | Check if branches can cleanly merge without updating (was `but base check`) |
| `but pr new -m "title\n\nbody" <branch>` | Create PR/MR with title/body — first line is title, rest is body (NOTE: shell does not expand `\n` in quotes — use `-F` for multiline) |
| `but pr new -F <file> <branch>` (alias `--file`) | Read PR title/body from file (first line = title, rest = body) |
| `but pr new -d <branch>` (alias `--draft`) | Create PR as draft |
| `but pr new -t <branch>` (alias `--default`) | Use default content from commits, skipping prompts (single commit → its message); required for GitLab |
| `but pr new -f <branch>` (alias `--with-force`) | Force push even if not fast-forward (defaults to true) |
| `but pr new -s <branch>` | Skip force-push protection checks |
| `but pr new --no-hooks <branch>` (alias `--no-verify`) | Bypass pre-push hooks |
| `but pr auto-merge <branch>` | Enable/disable auto-merge on a PR |
| `but pr set-draft <branch>` | Set existing PR as draft |
| `but pr set-ready <branch>` | Set existing PR as ready for review |
| `but pr template` | Select PR description template from repo |
| `but merge <branch>` | Merge a branch into local target branch (then runs the equivalent of `but pull`) |

> **Note:** `but push` is silent on success — no stdout is produced when the push completes cleanly. Output only appears when there's an error (non-fast-forward, auth failure, network issue, etc.). To confirm a push landed, run `git ls-remote --heads origin <branch>` and compare the SHA to your local commit.

## Operation History

| Command | Purpose |
|---------|---------|
| `but undo` | Undo the last operation (revert to previous snapshot) |
| `but redo` | **New**: redo the last undo |
| `but oplog` / `but oplog list` | View operation history (default: last 20 entries) |
| `but oplog snapshot` | Create an on-demand snapshot (optional `-m "msg"`) |
| `but oplog restore <oplog-sha>` | Restore workspace to a specific snapshot |

## Other

| Command | Purpose |
|---------|---------|
| `but gui` / `but .` | Open the GitButler GUI for current project |
| `but tui` | Open the interactive TUI |
| `but setup` | Set up a GitButler project from a git repo |
| `but setup --init` | Initialize a new git repo and set up GitButler |
| `but teardown` | Exit GitButler mode, return to normal Git workflow |
| `but teardown -c <branch>` (alias `--checkout-to`) | Override which local branch to check out on teardown |
| `but clean` | Remove empty branches (no local commits, no assigned changes) |
| `but clean --dry-run` | Preview which empty branches would be removed |
| `but clean --pull` | Pull latest from remote, then clean |
| `but clean --include-upstream` | Also remove branches with only upstream-only commits |
| `but move <branch> <target>` | Stack one branch on top of another (replaces old `but stack`) |
| `but move <branch> zz` | Tear off (unstack) a branch |
| `but config` | View configuration overview (user, forge, target, metrics, ui, ai) |
| `but config user set name "Name"` / `email "x@y"` | Set user identity (also `editor`) |
| `but config forge` | View configured forge accounts and auth status |
| `but config forge auth` | Authenticate with a forge provider (currently GitHub only) |
| `but config forge list-users` | List authenticated forge accounts |
| `but config forge forget <username>` | Forget a previously authenticated forge account |
| `but config target` | View/set target branch |
| `but config metrics` | View/set metrics collection |
| `but config ui set tui true` | Enable TUI mode for diff by default |
| `but config ai` | View/configure AI provider settings |
| `but alias add <name> <command>` | Create command shortcut |
| `but alias remove <name>` | Remove a command shortcut |
| `but alias list` | List all aliases |
| `but skill install` | Interactive: prompt for scope (repo/global) and format |
| `but skill install --global` | Install skill files into home directory |
| `but skill install --path <path>` | Install to a custom absolute or `~`-prefixed path |
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
- `--format <FORMAT>` — Output format: `human`, `agent`, `shell`, `json`, `none` (env `BUT_OUTPUT_FORMAT`). **Replaces the removed `--json` / `-j` flags** — use `--format json` for machine-readable output.
- `--status-after` — Print workspace status after mutation commands

## Environment Variables

- `BUT_OUTPUT_FORMAT` — Default output format (see `--format` above)
- `BUT_PAGER` — Pager for large outputs (default: `less`)
- `BUT_THEME` — Theme: `dark` or `light` (default: `dark`)
