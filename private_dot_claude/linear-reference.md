# Linear CLI - Full Command Reference

Use the `linear` CLI (v1.11.0) for managing Linear issues, projects, and initiatives from the terminal.

## Authentication

| Command | Purpose |
|---------|---------|
| `linear auth login` | Add a workspace credential |
| `linear auth logout [workspace]` | Remove a workspace credential |
| `linear auth list` | List configured workspaces |
| `linear auth default [workspace]` | Set the default workspace |
| `linear auth whoami` | Print info about authenticated user |
| `linear auth token` | Print the configured API token |

## Issues

| Command | Alias | Purpose |
|---------|-------|---------|
| `linear issue list --sort priority` | `linear i list` | List your issues (default: unstarted state) |
| `linear issue list -s started` | | List in-progress issues |
| `linear issue list --all-states` | | List issues across all states |
| `linear issue list -A` | | List issues for all assignees |
| `linear issue list -U` | | List unassigned issues |
| `linear issue list --project <name>` | | Filter by project |
| `linear issue list --team <key>` | | Filter by team |
| `linear issue list --cycle active` | | Filter by active cycle |
| `linear issue list --limit <n>` | | Limit results (default: 50, 0=unlimited) |
| `linear issue list --assignee <user>` | | Filter by specific assignee username |
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

## Issue Comments & Relations

| Command | Purpose |
|---------|---------|
| `linear issue comment add [issueId]` | Add a comment to an issue |
| `linear issue comment list [issueId]` | List comments on an issue |
| `linear issue comment update <commentId>` | Update an existing comment |
| `linear issue relation add <id> <type> <relatedId>` | Add relation between issues |
| `linear issue relation list [issueId]` | List relations for an issue |
| `linear issue attach <issueId> <filepath>` | Attach a file to an issue |

## Pull Requests (GitHub)

| Command | Purpose |
|---------|---------|
| `linear issue pr [issueId]` | Create GitHub PR with issue details |
| `linear issue pr [issueId] --draft` | Create as draft PR |
| `linear issue pr [issueId] --base <branch>` | Specify target branch |
| `linear issue pr [issueId] -t "title"` | Custom PR title (issue ID prefixed) |

## Projects & Initiatives

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
| `linear initiative-update create <initId>` | `linear iu c` | Create initiative status update (timeline post) |
| `linear initiative-update list <initId>` | `linear iu l` | List initiative status updates |

## Cycles

| Command | Alias | Purpose |
|---------|-------|---------|
| `linear cycle list` | `linear cy list` | List cycles for a team |
| `linear cycle list --team <key>` | | List cycles for a specific team |
| `linear cycle view <cycleRef>` | `linear cy v` | View cycle details |

## Teams, Labels & Documents

| Command | Purpose |
|---------|---------|
| `linear team list` | List teams |
| `linear team members [teamKey]` | List team members |
| `linear label list` | List issue labels |
| `linear label create` | Create a new label |
| `linear document list` | List documents (alias: `docs`, `doc`) |
| `linear document view <id>` | View document content |
| `linear document create` | Create a new document |
| `linear document update <id>` | Update a document |

## Raw API & Config

| Command | Purpose |
|---------|---------|
| `linear api <query>` | Make a raw GraphQL API request |
| `linear api <query> --variable key=value` | GraphQL with variables |
| `linear api <query> --paginate` | Auto-paginate a connection field |
| `linear schema` | Print the GraphQL schema (SDL) to stdout |
| `linear schema --json` | Print schema as JSON introspection result |
| `linear schema -o <file>` | Write schema to file |
| `linear config` | Interactively generate `.linear.toml` config |
| `linear completions` | Generate shell completions |

## Global Options

- `-w, --workspace <slug>` — Target a specific workspace
- `LINEAR_DEBUG=1` — Show full error details with stack traces
