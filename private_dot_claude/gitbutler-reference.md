# GitButler CLI - Full Command Reference

> Reference verified against `but 0.22.0`.

## Breaking changes since 0.20.x — read this first

**Output format reverted to `--json`.** The `--format <FORMAT>` flag introduced in 0.20 is
**gone**. Use the global `--json` flag again (env `BUT_OUTPUT_FORMAT` accepts `human` or
`json`). So `but status --format json` is now `but status --json`.

**`but rub` was retired.** It has no direct replacement — the operation is now split across
three explicit commands:

| Old `rub` usage | New command |
|-----------------|-------------|
| `but rub <file> <branch>` (stage) | `but commit -m "msg" -b <branch> <file>` (commit directly) |
| `but rub zz <branch>` (stage all) | `but commit -m "msg" -b <branch>` (all uncommitted is the default) |
| `but rub <file> <commit>` (amend) | `but amend -t <commit> <file>` |
| `but rub <commitA> <commitB>` (squash) | `but squash <commitA> -t <commitB>` |
| `but rub <commit> <branch>` (move) | `but move <commit> -b <branch>` |
| `but rub <file-in-commit> zz` (uncommit) | `but uncommit <commit>:<file>` |

**Other removed commands:** `but stage`, `but mark`, `but unmark`, `but merge`, `but base`,
`but stack`. There is no longer a staging step at all — `but commit` takes the changes directly.

**New commands:** `but land`, `but switch`, `but agent`.

**Redesigned commands (incompatible flags):** `commit`, `squash`, `move`, `amend`, `uncommit`.
See their sections below.

## Inspection

| Command | Purpose |
|---------|---------|
| `but status` | Overview of workspace state (uncommitted files, branches, commits, base) |
| `but status --json` | Machine-readable state with CLI IDs |
| `but status -f` | Also list committed files (needed to get committed-file CLI IDs) |
| `but status -v` | Verbose: commit author and timestamp |
| `but status -u` | Detailed list of unintegrated upstream commits |
| `but status -r` | Force sync of PRs from the forge first |
| `but status --no-hint` | Suppress the command hints at end of output |
| `but status --short` | Compact one-line-per-change output (works but is hidden from `--help`) |
| `but diff` | Diff of all uncommitted changes |
| `but diff <cliId>` | Diff for one entity: uncommitted file, branch, stack, commit, or file-in-commit (one only) |
| `but diff --tui` / `--no-tui` | Force / disable the interactive TUI diff viewer |
| `but show <commit-or-branch>` | Commit details, or the commit list for a branch |
| `but show <target> -v` | Full messages and changed files |
| `but help cli-ids` | Built-in help topic explaining CLI IDs |

## Branching

| Command | Purpose |
|---------|---------|
| `but branch new <name>` | Create a new parallel branch (name optional — generated if omitted) |
| `but branch new -a <anchor> <name>` | Create a stacked branch; anchor is a commit ID or branch name |
| `but branch list` | Active branch + 20 most recently updated |
| `but branch list <filter>` | Case-insensitive substring filter on branch name |
| `but branch list -a` / `-l` / `-r` | All branches / local only / remote only |
| `but branch list --review` | Also fetch PR/MR status (slow — queries the forge) |
| `but branch list --no-check --no-ahead` | Skip clean-merge check and ahead-count (faster) |
| `but branch list --empty` | Include branches with no commits (hidden by default) |
| `but branch show <branch>` | Commits ahead of base for a branch |
| `but branch show <branch> -f` | Also show files modified per commit with line counts |
| `but branch show <branch> --check` | Check clean merge into upstream, identify conflicting commits |
| `but branch show <branch> --ai` | AI summary of the branch changes |
| `but branch delete <branch>` (alias `-d`) | Delete branch and its commits (prompts if unpushed) |
| `but branch update <branch>` (alias `-u`) | Integrate the remote counterpart into your local branch |
| `but branch update -s <strategy> <branch>` | `pull-rebase` (default), `smart-squash`, `merge`, `pick-remote` |
| `but branch update --dry-run <branch>` | Preview result (`-v` adds divergence detail, `-i` opens the integration script) |
| `but apply <branch>` | Apply (unstash) an unapplied branch into the workspace |
| `but unapply <branch-or-cliId>` | Unapply (stash) a branch — unapplies the whole containing stack |
| `but clean` | Remove empty branches (no local commits, no assigned changes) |
| `but clean --dry-run` / `--pull` / `--include-upstream` | Preview / pull first / also drop upstream-only branches |
| `but switch <branch>` | Leave the workspace and check out a local branch directly |
| `but switch -w` (alias `--workspace`) | Switch back to `gitbutler/workspace` |
| `but switch -n [<name>]` | Create a branch at the project target and switch to it |

## Committing

`but commit` includes **all uncommitted changes by default**. Narrow it with positional
`CHANGES` (file or hunk CLI IDs) or `-i`.

| Command | Purpose |
|---------|---------|
| `but commit -m "msg"` | Commit all uncommitted changes (creates a branch if none applied; uses the single stack tip if there is one) |
| `but commit -m "msg" -b <branch>` | Commit onto BRANCH; **creates it as an unstacked branch if it doesn't exist** (replaces the old `-c`) |
| `but commit -m "msg" -b` | Commit onto a new unstacked branch with a generated name |
| `but commit -m "msg" -b <branch> <cliId>...` | Commit only the named files/hunks (replaces the old `-p`) |
| `but commit -m "title" -m "body"` | `-m` is repeatable — values are joined with a blank line between them |
| `but commit -A <branch-or-commit>` (alias `--above`) | Place the commit above a branch or commit |
| `but commit -B <branch-or-commit>` (alias `--below`) | Place the commit below a branch or commit |
| `but commit -i` | Open the TUI to interactively pick what to commit |
| `but commit --no-message` | Commit without a message (otherwise an editor opens if `-m` is absent) |
| `but commit --empty` | Force an empty commit regardless of repo state (replaces `but commit empty`) |
| `but commit --allow-merged` | Permit targeting history already merged upstream |

> Only one of `-b` / `-A` / `-B` may be given at a time.
>
> **Removed from `commit` in 0.22:** `--only` / `-o`, `-c`, `-p`, `--ai`, `-n` / `--no-hooks`,
> `-a`, `--message-file`, `--diff` / `--no-diff`, and the `commit empty` subcommand. `-i` now
> means *interactive TUI*, not *AI-generated message*.

## Editing Commits

### squash — combine things into a target

`but squash [SOURCES]... -t <TARGET>`. Sources must all be the same kind: commits, branches,
uncommitted files/hunks, `zz`, or committed files (all from one commit).

| Command | Purpose |
|---------|---------|
| `but squash <branch>` | No target + one branch source → squash all commits on that branch |
| `but squash <commitA> -t <commitB>` | Squash A into B |
| `but squash <branchA> -t <commit>` | Squash all of branchA's commits into the commit; branchA is removed |
| `but squash -t <commit>` | Sources omitted → the uncommitted area (`zz`) is squashed in |
| `but squash <commit> -t zz` | Target `zz` → uncommit the commit |
| `but squash <commit>:<file> -t <commit2>` | Move a committed file between commits |
| `but squash ... -m "msg"` | Message for the resulting commit (repeatable, joined by blank lines) |
| `but squash ... -u` (alias `--use-target-message`) | Keep the target's message, discard sources' |
| `but squash ... --use-source-message` | Keep the sources' message, discard the target's |
| `but squash ... --no-message` | Resulting commit has no message |
| `but squash ... --allow-merged` | Permit targeting merged history |

> Message flags cannot be used when TARGET is `zz`. Without a message flag, an editor may open.

### move — reposition commits, files, or a branch

`but move <SOURCES>... <placement>` — a placement flag is **required**.

| Command | Purpose |
|---------|---------|
| `but move <commit> -A <branch-or-commit>` | Place above (alias `--above`) |
| `but move <commit> -B <branch-or-commit>` | Place below (alias `--below`) |
| `but move <sources> -b <branch>` | Place onto BRANCH, creating it if absent |
| `but move <sources> --unstack` | Tear off onto a new generated unstacked branch |

> Sources are commits, committed files (all from one commit), or a **single** branch — never mixed.
> Moving a committed file relative to a commit/branch creates a new commit for it; unstacking a
> committed file creates both a commit and a branch.

### Others

| Command | Purpose |
|---------|---------|
| `but amend -t <commit-or-branch> [sources...]` | Amend uncommitted files/hunks into a commit (or a branch's tip). Sources omitted → all of `zz` |
| `but absorb` | Auto-amend uncommitted changes into the commits they belong to |
| `but absorb <cliId>` | Absorb one uncommitted file |
| `but absorb --dry-run` | Show the absorption plan without applying it |
| `but uncommit <commit>` | Uncommit a whole commit back to the uncommitted area |
| `but uncommit <commit>:<file>` | Uncommit a single committed file |
| `but reword <commit> -m "msg"` | Edit a commit message |
| `but reword <branch> -m "name"` | Rename a branch |
| `but reword <commit> -f` | Reformat the existing message to 72-char wrap, no editor |
| `but reword <commit> --diff` / `--no-diff` | Force show / hide the diff in the editor |
| `but pick <source> [target-branch]` | Cherry-pick from an unapplied branch (source = SHA, CLI ID, or branch name) |
| `but discard <changes>...` | Discard branches, commits, committed files, uncommitted files/hunks, or `zz` |

> `amend`, `squash`, `move`, `reword`, `uncommit` and `absorb` all take `--allow-merged` to
> override the default refusal to touch history already landed on the target branch.
>
> `discard` requires all arguments be the same kind; committed files must share a commit. The
> whole operation is one oplog entry, so `but undo` reverses it.

## Conflict Resolution

| Command | Purpose |
|---------|---------|
| `but resolve <commit>` | Enter resolution mode for a conflicted commit |
| `but resolve status` | Show remaining conflicted files |
| `but resolve finish` | Finalize and return to workspace mode |
| `but resolve cancel` | Abort and return to workspace mode |
| `but resolve <commit> --ai` | Resolve that commit with the configured AI model in one step |
| `but resolve --ai` | Resolve **all** conflicted commits, oldest first (undo with `but undo`) |

## Server Interactions

> `but mr` is an alias for `but pr` — use whichever reads better for GitHub PRs vs GitLab MRs.

| Command | Purpose |
|---------|---------|
| `but push <branch>` | Push a branch/stack to remote (use instead of `git push`) |
| `but push` | Non-interactive: push all branches with unpushed commits |
| `but push -d <branch>` | Dry run |
| `but push -f <branch>` (alias `--with-force`) | Force push even if not fast-forward |
| `but push -s <branch>` | Skip force-push protection checks |
| `but push --no-hooks <branch>` (alias `--no-verify`) | Bypass pre-push hooks |
| `but pull` | Fetch and rebase all applied branches onto the updated target |
| `but pull -c` (alias `--check`) | Only check for clean merge, don't update (was `but base check`) |
| `but pr new <branch> -m "title"` | Create PR/MR — first line is title, rest is body (shell won't expand `\n`; use `-F`) |
| `but pr new <branch> -F <file>` (alias `--file`) | Read title/body from file (line 1 = title, rest = body) |
| `but pr new <branch> -d` (alias `--draft`) | Create as draft |
| `but pr new <branch> -t` (alias `--default`) | Use default content from commits, skip prompts (single commit → its message); required for GitLab |
| `but pr new <branch> -f` / `-s` / `--no-hooks` | Force push / skip protection / bypass pre-push hooks |
| `but pr auto-merge <selector>` | Enable auto-merge (`-d` / `--off` to disable) |
| `but pr set-draft <selector>` / `but pr set-ready <selector>` | Toggle draft state on existing PRs |
| `but pr template [path]` | Select the PR description template from the repo |
| `but land <branch>` | **New**: land a branch straight onto the target, bypassing PR review |
| `but land <branch> --yes` | Skip the confirmation prompt (for scripts) |
| `but land <branch> --no-ff` | Always create a merge commit |
| `but land <branch> --whole-stack` | Land a whole stack; BRANCH must be the top segment |

> `pr auto-merge` / `set-draft` / `set-ready` selectors are comma-separated branch names, branch
> IDs, stack IDs, or numeric PR/MR IDs.
>
> **`but land` bypasses code review.** It fast-forwards the target where possible, otherwise
> creates a merge commit, then pushes and reconciles remaining branches like `but pull`. Not
> easily reversible, hence the confirmation. If the project reviews via PRs, use `but push` +
> `but pr new` instead. Protected branches will reject a land.

> **Note:** as of 0.22 `but push` reports success explicitly, printing
> `✓ Push completed successfully` and the `<branch> -> origin/<branch> (… -> <sha>)` mapping.
> (Older versions were silent on success.) To double-check independently, run
> `git ls-remote --heads origin <branch>` and compare the SHA to your local commit.

## Operation History

| Command | Purpose |
|---------|---------|
| `but undo` | Undo the last operation |
| `but redo` | Redo the last undo |
| `but oplog` / `but oplog list` | Operation history (last 20 entries) |
| `but oplog list --since <sha>` | Start from a given oplog SHA instead of head |
| `but oplog list -s` (alias `--snapshot`) | Only on-demand snapshot entries |
| `but oplog snapshot -m "msg"` | Create an on-demand snapshot |
| `but oplog restore <oplog-sha>` | Restore the workspace to a snapshot |

## Setup, Config, and Tooling

| Command | Purpose |
|---------|---------|
| `but setup` | Set up a GitButler project from a git repo in the current directory |
| `but setup --init` | Also `git init` an empty repo first (for CI) |
| `but teardown` | Exit GitButler mode, return to a normal Git workflow |
| `but teardown -c <branch>` (alias `--checkout-to`) | Override which local branch is checked out |
| `but gui` / `but .` | Open the GitButler GUI (`-n` for a new window) |
| `but tui` | Open the interactive terminal workspace |
| `but tui --remember-selection` | Save and restore the TUI selection between launches |
| `but config` | Overview: user, forge, target, metrics, ui, ai |
| `but config user set name "Name"` / `email` / `editor` | Set user identity |
| `but config forge` | View configured forge accounts and auth status |
| `but config forge auth` / `list-users` / `forget <user>` | Manage forge authentication |
| `but config target` | View or set the target branch |
| `but config push-remote [<remote>]` | **New**: view/set the push remote without changing the target |
| `but config feature [<flag>] [enable\|disable]` | **New**: feature flags (`unapply-v3-pgm`, `single-branch`) |
| `but config metrics` | View or set metrics collection |
| `but config ui set tui true` | Make the diff TUI the default (`unset` to remove) |
| `but config ai` | View or configure the AI provider |
| `but alias add <name> <cmd>` | e.g. `but alias add stv "status --verbose"` |
| `but alias list` / `but alias remove <name>` | Manage aliases |
| `but skill install` | Install the GitButler agent skill (prompts for scope, then format) |
| `but skill install -g` / `-p <path>` / `-d` | Global / custom path / refresh existing installs in place |
| `but skill check` | Check installed skills against the CLI version (`-u` to auto-update, `-g`/`-l` to scope) |
| `but agent` / `but agent setup` | **New**: wizard to install skills and write steering into agent instruction files |
| `but agent setup --print` | Print the default steering text without touching files |
| `but update check` / `install [target]` / `suppress` | CLI and desktop-app updates (`install nightly`, `install 0.18.7`) |
| `but completions zsh` | Shell completions — `eval "$(but completions zsh)"` in `~/.zshrc` |

## CLI IDs

From `but help cli-ids`:

- **Commit** — full commit ID, full change ID, or any unique prefix of either (`but status`
  highlights the shortest usable prefix). Change IDs are stable across rebases; commit IDs aren't.
- **Branch** — full branch name, or the short ID shown by `but status`
- **Uncommitted file** — a path-derived ID, typically 1–3 characters
- **Uncommitted hunk** — `<file_id>:<hunk_id>`; run `but diff` to list them
- **Uncommitted area** — always `zz`
- **Committed file** — `<commit_id>:<file_id>`; run `but status -f` to list them

IDs are context-dependent and **change** when files are written, commits are made or rearranged,
or branches are created/deleted. Re-run `but status` if anything has mutated.

## Global Options

- `-C <path>` — run as if started in PATH. **Always pass this, before the subcommand**, to target
  the correct repository: `but -C /path/to/repo status`
- `--json` — machine-readable output (replaces the 0.20-era `--format json`)
- `--status-after` — append workspace status after a mutation command; use when the next step
  needs IDs from the resulting workspace
- `--allow-merged` — on mutation commands, permit targeting history already landed upstream

## Environment Variables

- `BUT_OUTPUT_FORMAT` — output format when `--json` isn't passed: `human` or `json`
- `BUT_PAGER` — pager for large outputs (default: `less`)
- `BUT_THEME` — `dark` or `light` (default: `dark`)
