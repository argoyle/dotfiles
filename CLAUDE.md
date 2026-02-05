# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a chezmoi dotfiles repository managing development environment configuration across macOS machines. It manages both dotfiles and a complete multi-project development workspace under the `Source/` directory.

## Chezmoi File Naming Conventions

- `dot_` prefix: Creates hidden files (e.g., `dot_bashrc.tmpl` → `~/.bashrc`)
- `private_` prefix: Marks sensitive files (SSH keys, tokens)
- `executable_` prefix: Makes files executable
- `.tmpl` suffix: Processed as Go templates with access to LastPass secrets
- `run_once_*.sh`: Executes only once during `chezmoi apply`

## Secret Management

All sensitive data is retrieved from LastPass using template functions:
```
{{ (index (lastpass "path/to/secret") 0).note.field }}
```

The repository owner must be logged in via `lpass login joakim@unbound.se` before applying changes.

## Source Directory Structure

The `Source/` directory mirrors `~/Source` and contains:

- **CustomerProjects/**: Client project directories (GoodFeed, Intersolia, Keenfinity, LifeInside, Paidit, Sensapp, etc.)
- **shiny/**: Microservices architecture with multiple Go services (accounting, authz, company, consumer, employee, invoice, notification, salary, time)
- **dancefinder/**: Application with frontend
- **Infrastructure/**: Terraform configurations for Auth0, AWS, CloudAMQP, GitLab
- **Opzkit/**: CI/CD and infrastructure tooling
- Each project typically has:
  - `.envrc` file for direnv automatic environment switching
  - `dot_bin/` directory with project-specific scripts
  - Infrastructure configs often use `.auto.tfvars.tmpl` files

## Common Commands

### Chezmoi Operations
```bash
chezmoi apply         # Apply configuration changes
chezmoi diff          # Preview what would change
cm                    # Alias for chezmoi
```

### Package Management
```bash
bup                   # Update all brew packages (checks Brewfile first)
brew bundle --file ~/.local/share/Brewfile
```

### Custom Shell Functions

Defined in `dot_functions`:

- `kind_load` - Load docker image into kind cluster (searches upward for `.buildtools.yaml`)
- `ldeploy` - Load and deploy to local kind cluster
- `bup` - Safely update brew packages by validating Brewfile first
- `ecr` - Login to AWS ECR
- `reload` - Reload zsh configuration
- `but-pull-all` - Update all GitButler projects to latest remote state (supports `-f/--force` and `-t/--timeout`)
- `k8s-rds-tunnel` - Port forward to RDS via AWS SSM through k8s node (uses `K8S_RDS_CONFIG`)

Git repository management aliases (from `dot_aliases`):
- `updrepo` - Update all git repos in subdirectories
- `dirtyrepo` - Check repos with uncommitted changes
- `branches` - List all branches across repos
- `cdb` - Checkout default branch in all repos
- `prune` - Remove local branches deleted remotely
- `gup` - Git pull with rebase and autostash

### Database Management

Project-specific `recreate_db` scripts in `Source/*/dot_bin/` for:
- shiny
- dancefinder
- GoodFeed

These scripts dump production data and restore locally to OrbStack/kind clusters.

## Development Workflow Conventions

### Git Commits
- Always follow conventional commits format
- Always `git add` all files before running `pre-commit`
- Don't commit if current branch is `gitbutler/workspace`

### Go Development
- Run `go generate ./...` when changing GraphQL schemas
- Use gobrew for Go version management

### Migrations
- Name goose migrations with numeric prefix: `YYYYMMDDHHmmss` format

### Build Tools Pattern
Projects use `.buildtools.yaml` to define deployment targets:
- Contains registry configuration
- Defines environments (local, staging, prod) with k8s context and namespace
- Used by `kind_load` function to determine cluster name and image naming

## Environment Management

### Direnv Integration
- Global `.envrc` at Source level sets AWS/GitLab credentials
- Project-level `.envrc` files use `source_up .envrc` to inherit global settings
- Automatic environment switching when entering directories
- Supports both `use nvm` (legacy) and `use fnm` for Node.js version management
  - `use fnm` - Auto-detect from .nvmrc or .node-version
  - `use fnm 18.0.0` - Specify version directly
  - `use fnm package.json` - Parse from package.json engines field

### Hostname-Based Configuration
- "gwaihir": Main development machine (full setup)
- "A6436902": Work machine (Jeppesen-only, limited setup)
- Controlled via `.chezmoiignore`

## Technology Stack

**Container/Kubernetes**:
- OrbStack provides local Kubernetes (kind clusters)
- kubectl, helm, kustomize, k9s, stern available
- Cluster naming convention: `$(basename $(dirname $PWD) | tr '[:upper:]' '[:lower:]')`

**AWS**:
- Use `aws-sso-profile <profile>` (aliased as `sso`) to assume roles
- Integration with aws-sso-cli for SSO authentication

**Infrastructure**:
- Terraform/OpenTofu with tfswitch for version management
- GitLab CI/CD
- Docker with OrbStack

**Languages**:
- Go (gobrew), Node.js (fnm), Python (pyenv, pipx), Java (temurin 17), Ruby (rbenv), Scala (sbt)

**Databases**:
- PostgreSQL 17 (runs in OrbStack containers)
- MySQL client 8.4

## Shell Configuration

Configuration is split across files (all sourced from `.zshrc`):
- `.functions` - Reusable shell functions
- `.aliases` - Command shortcuts
- `.exports` - Environment variables
- `.paths` - PATH modifications
- `.completions` - Shell completions
- `.auths` - Authentication tokens (private)

## Machine Sync Workflow

Before syncing machines, clean up temporary directories on old machine:
```bash
find Source -type d -name node_modules | xargs rm -rf
find Source -type d -name .terraform | xargs rm -rf
find Source -type d -name .direnv | xargs rm -rf
```

Also remove old JetBrains configurations in `~/Library/Application Support/JetBrains`.

## Tmux

- Auto-launches on compatible terminals (rio, alacritty, ghostty, xterm-256color)
- Plugin installation: `Ctrl-space I` (capital I)
- Reload config: `tmux source-file ~/.tmux.conf`
- Restore environment: `Ctrl-space Ctrl-r`

## Window Management

- **Rectangle** is used for window tiling and management on macOS
- Automatically configured via `run_once_setup_rectangle.sh` on first setup
- Replaces legacy Hammerspoon setup
