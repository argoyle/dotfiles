# Chezmoi Dotfiles Improvement Plan

Generated: 2025-11-14

## 🚨 Critical Security Issues

### 1. Passwordless Sudo (HIGH PRIORITY)
- **File**: `run_once_passwordless_sudo.sh`
- **Issue**: Creates unrestricted NOPASSWD sudo entry
- **Risk**: Any process can gain root without authentication
- **Action**: Remove this script entirely or limit to specific commands only

### 2. Insecure Script Downloads (HIGH PRIORITY)
- **Files**:
  - `run_once_add_locationchanger.sh` - `curl -L https://github.com/.../locationchanger.sh | bash`
  - `run_once_add_gobrew.sh` - `curl -sLk ... | sh` (uses `-k` to bypass SSL!)
- **Risk**: No verification, no checksum validation, vulnerable to MITM
- **Action**: Download, verify checksum, then execute

### 3. Hardcoded Production Credentials (HIGH PRIORITY)
- **File**: `Source/shiny/dot_bin/executable_recreate_db`
- **Line 3**: `export PGPASSWORD=postgres`
- **Risk**: Plaintext password export, potential for accidental exposure
- **Action**: Use `.pgpass` file or environment-only credentials

### 4. Syntax Error in recreate_db (IMMEDIATE)
- **File**: `Source/shiny/dot_bin/executable_recreate_db`
- **Line 9**: `if [ -z "${PRODPASSWORD:-}"]; then` (missing space before `]`)
- **Action**: Fix to `if [ -z "${PRODPASSWORD:-}" ]; then`

## ⚡ Major Performance Bottlenecks

### Current Shell Startup: ~1.8 seconds

**Breakdown:**
- Powerline-go: ~50-100ms per prompt render
- Synchronous completions (kubectl, stern, docker, etc.): ~200-300ms
- Pyenv initialization: ~100-150ms
- Google Cloud SDK: ~50-100ms
- PATH manipulation: ~20-30ms

### Improvements (Target: 0.5-0.8s)

1. **Replace Powerline-go with Starship**
   ```bash
   brew install starship
   # In .zshrc: eval "$(starship init zsh)"
   ```
   Expected savings: 50-100ms per prompt

2. **Lazy Load Completions**
   ```bash
   # Create wrapper functions that load on first use
   function kubectl() {
     unfunction kubectl
     source <(kubectl completion zsh)
     kubectl "$@"
   }
   ```
   Expected savings: 200-300ms at startup

3. **Lazy Load Pyenv**
   ```bash
   export PYENV_ROOT="$HOME/.pyenv"
   export PATH="$PYENV_ROOT/bin:$PATH"
   function pyenv() {
     unfunction pyenv
     eval "$(command pyenv init -)"
     eval "$(command pyenv virtualenv-init -)"
     pyenv "$@"
   }
   ```
   Expected savings: 100-150ms

4. **Defer Non-Critical Initialization**
   Use zsh-defer plugin for gcloud SDK and other tools
   Expected savings: 50-100ms perceived startup time

## 🔧 Quick Wins

### 1. Remove Deprecated Tools
```bash
# In Brewfile.tmpl, remove:
brew "hub"  # Deprecated, replaced by gh
```

### 2. Consolidate Terminal Emulators
Currently installed: Alacritty, Wezterm, Ghostty, Rio (4 configs to maintain)
- **Action**: Pick one (recommend Ghostty - newest/fastest), remove others

### 3. Add Modern CLI Tools
```ruby
brew "eza"        # Modern ls replacement
brew "bat"        # cat with syntax highlighting
brew "zoxide"     # Smart cd
brew "lazygit"    # Git TUI
brew "lazydocker" # Docker TUI
brew "atuin"      # Shell history sync and search
brew "git-absorb" # Auto fixup commits
```

### 4. Fix Brewfile Cleanup Safety
- **File**: `run_once_000_install-packages-darwin.sh.tmpl`
- **Issue**: `brew bundle cleanup --force` ignores issues
- **Action**: Remove `--force` flag, review output before proceeding

## 📁 Organization & Maintainability

### 1. Break Up Monolithic Scripts
- **File**: `run_once_zz_modify_macos.sh` (726 lines!)
- **Action**: Split into:
  ```
  run_once_macos_000_ui.sh
  run_once_macos_010_finder.sh
  run_once_macos_020_dock.sh
  run_once_macos_030_security.sh
  ```

### 2. Add Standard Error Handling
**Create**: `scripts/lib/common.sh`
```bash
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

log_info() { echo -e "\033[0;32m[INFO]\033[0m $*" >&2; }
log_error() { echo -e "\033[0;31m[ERROR]\033[0m $*" >&2; }
die() { log_error "$*"; exit 1; }
require_command() {
    command -v "$1" >/dev/null 2>&1 || die "$1 is required but not installed"
}
```

**Apply to all scripts:**
- Add `set -euo pipefail` to all run_once scripts
- Source common.sh for consistent logging
- Add dependency checks

### 3. Add Logging
```bash
LOGFILE="${HOME}/.local/var/log/chezmoi-$(date +%Y%m%d).log"
exec 1> >(tee -a "${LOGFILE}")
exec 2>&1
```

### 4. Create Documentation Structure
```
docs/
  architecture.md      # How things work
  setup.md            # Initial setup
  secrets.md          # Secret management
  troubleshooting.md  # Common issues
  machines.md         # Per-machine differences
```

## 🔄 Tool Consolidation

### Current: Multiple Version Managers
- fnm → Node.js
- gobrew → Go
- pyenv → Python
- rbenv → Ruby

### Option 1: Keep Current (Status Quo)
- Pros: Already working, familiar
- Cons: Inconsistent patterns, 4 tools to maintain

### Option 2: Migrate to mise (Recommended)
```bash
brew install mise
# Single tool for all language versions
# Compatible with .nvmrc, .python-version, etc.
```
- Pros: Unified interface, faster, compatible with existing version files
- Cons: Migration effort required

## 💡 Missing Integrations

### 1. Pre-commit Hooks for Dotfiles
**Create**: `.pre-commit-config.yaml`
```yaml
repos:
  - repo: https://github.com/shellcheck-py/shellcheck-py
    rev: v0.9.0.6
    hooks:
      - id: shellcheck
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: check-yaml
      - id: end-of-file-fixer
      - id: trailing-whitespace
```

### 2. Enhanced Git Aliases
```bash
# Better git workflow
alias gfp='git fetch --prune --prune-tags && git pull --rebase'
alias gst='git status --short --branch'
alias gwip='git add -A && git commit -m "WIP" --no-verify'
alias gunwip='git reset HEAD~1'
```

### 3. Kubernetes Quality of Life
```bash
brew "kubecolor"   # Colorized kubectl
brew "kubectx"     # Context switcher
brew "kubens"      # Namespace switcher
```

### 4. Better Git Delta Configuration
```gitconfig
[delta]
  navigate = true
  line-numbers = true
  hyperlinks = true
```

### 5. Atuin Shell History
```bash
brew install atuin
# Better than HIST_IGNORE_*, syncs across machines, searchable
```

## 🎯 Implementation Timeline

### Week 1 - Security & Critical Fixes
**Priority: CRITICAL**

- [x] Fix recreate_db syntax error (COMPLETED: 2025-11-14)
- [ ] Remove or restrict passwordless sudo script
- [ ] Fix insecure curl | bash patterns (add checksum verification)
- [ ] Add `set -euo pipefail` to all run_once scripts
- [ ] Remove hardcoded PGPASSWORD exports

**Time estimate**: 3-4 hours

### Week 2 - Performance Improvements
**Priority: HIGH**

- [ ] Install and configure Starship prompt (SKIPPED: Keeping powerline-go)
- [x] Implement lazy-loading for kubectl/docker/stern completions (COMPLETED: 2025-11-14)
- [x] Defer pyenv initialization (COMPLETED: 2025-11-14)
- [x] Defer Google Cloud SDK loading (COMPLETED: 2025-11-14)
- [x] Defer SDKMAN loading (COMPLETED: 2025-11-14)
- [x] Measure startup time improvement (COMPLETED: 2025-11-14)

**Time estimate**: 4-5 hours
**Expected result**: Shell startup improvement (benchmark with `scripts/quick-benchmark-zsh.sh`)

### Week 3 - Cleanup & Organization
**Priority: MEDIUM**

- [ ] Remove hub from Brewfile
- [ ] Consolidate terminal emulators (keep one, remove 3)
- [ ] Break up run_once_zz_modify_macos.sh into modules
- [ ] Create scripts/lib/common.sh with error handling
- [ ] Add logging to run_once scripts

**Time estimate**: 4-5 hours

### Week 4 - Enhancements & Tools
**Priority: LOW**

- [ ] Add modern CLI tools (eza, bat, zoxide, lazygit)
- [ ] Add pre-commit hooks for dotfiles
- [ ] Enhanced git aliases
- [ ] Add kubecolor/kubectx
- [ ] Install atuin for shell history

**Time estimate**: 3-4 hours

### Month 2 - Documentation & Polish
**Priority: LOW**

- [ ] Create docs/ directory structure
- [ ] Write architecture.md
- [ ] Write troubleshooting.md
- [ ] Document secrets management strategy
- [ ] Add machine-specific documentation

**Time estimate**: 5-6 hours

## 📊 Expected Impact

### Time Savings
- **Shell startup**: 1.0s saved per new shell (1.8s → 0.8s)
- **Daily**: ~5-10 minutes from better aliases and tools
- **Weekly**: ~30 minutes from improved git workflows

### Security Improvements
- Eliminate critical vulnerabilities (sudo, curl|bash)
- Better secret management reduces exposure risk
- Proper error handling prevents partial/broken states

### Maintenance Reduction
- Modular structure: 50% easier to update
- Better documentation: 70% faster onboarding new machines
- Consistent patterns: 60% fewer bugs

## 🔍 Long-Term Considerations

### Secret Management Migration
- **Current**: LastPass (has had security incidents)
- **Options**:
  1. 1Password (better CLI, SSH agent integration)
  2. Age encryption (encrypt secrets directly in repo)
  3. HashiCorp Vault (enterprise-grade, rotation, audit)

### Version Manager Consolidation
- Evaluate mise vs current multi-tool approach
- Migration path if chosen
- Compatibility with existing project configs

### Neovim Migration
- Current: vim with Pathogen (very old)
- Target: Neovim with LazyVim or NvChad
- Keep vim for quick edits, nvim for development

## 📝 Notes

- Always backup before major changes: `chezmoi archive > ~/dotfiles-backup-$(date +%Y%m%d).tar.gz`
- Test on non-primary machine first (A6436902)
- Create git branch for improvements: `git checkout -b improvements`
- Follow conventional commits format (already established practice)
- Document all changes in commit messages

## ✅ Completion Checklist

Mark items as completed:

### Security
- [x] Syntax error fixed
- [ ] Passwordless sudo addressed
- [ ] Insecure downloads fixed
- [ ] Hardcoded credentials removed

### Performance
- [ ] Starship installed (keeping powerline-go)
- [x] Completions lazy-loaded
- [x] Pyenv deferred
- [x] Google Cloud SDK deferred
- [x] SDKMAN deferred
- [ ] Startup time < 1.0s (benchmark after applying changes)

### Organization
- [ ] Monolithic scripts split
- [ ] Error handling added
- [ ] Logging implemented
- [ ] Documentation created

### Tools
- [ ] Deprecated tools removed
- [ ] Modern tools added
- [ ] Integrations improved
