# Performance Improvements - November 2025

## Summary

Implemented lazy-loading and deferred initialization for shell startup performance optimization.

## Changes Made

### 1. Lazy-Loaded Completions (`dot_completions`)

**Before**: All completions loaded synchronously at startup
```bash
source <(kubectl completion zsh)
source <(docker completion zsh)
source <(stern --completion=zsh)
# ... etc
```

**After**: Completions load on first use of each command
```bash
kubectl() {
  unfunction kubectl
  source <(command kubectl completion zsh)
  kubectl "$@"
}
```

**Affected Commands**:
- docker
- stern
- kubectl
- kops
- kind
- chezmoi
- ngrok

**Expected Savings**: ~200-300ms at startup

### 2. Deferred Pyenv Initialization (`dot_zshrc.tmpl`)

**Before**: Full pyenv initialization at startup
```bash
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
```

**After**: PATH setup immediate, full init on first use
```bash
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

pyenv() {
  unfunction pyenv
  eval "$(command pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
  pyenv "$@"
}
```

**Expected Savings**: ~100-150ms at startup

### 3. Deferred Google Cloud SDK (`dot_zshrc.tmpl`)

**Before**: Immediate loading of path and completion
```bash
source "$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source "$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
```

**After**: Path immediate, completion in background
```bash
source "$gcloud_path/path.zsh.inc"
(sleep 0.1 && source "$gcloud_path/completion.zsh.inc") &!
```

**Expected Savings**: ~50-100ms perceived startup time

### 4. Deferred SDKMAN Initialization (`dot_zshrc.tmpl`)

**Before**: Immediate SDKMAN initialization
```bash
source "/Users/argoyle/.sdkman/bin/sdkman-init.sh"
```

**After**: Background loading with delay
```bash
export SDKMAN_DIR="/Users/argoyle/.sdkman"
(sleep 0.1 && source "$SDKMAN_DIR/bin/sdkman-init.sh") &!
```

**Expected Savings**: ~30-50ms perceived startup time

### 5. Bash Compatibility (`dot_bashrc.tmpl`)

Added lazy-loading for pyenv in bash for consistency with zsh.

## Total Expected Impact

**Previous Baseline**: ~1.8 seconds
**Expected Improvement**: ~380-600ms reduction
**Target**: ~1.0-1.2 seconds (keeping powerline-go)

## Measuring Performance

Two scripts created for benchmarking:

### Quick Benchmark
```bash
bash ~/.local/share/chezmoi/scripts/quick-benchmark-zsh.sh
```

### Detailed Measurement
```bash
bash ~/.local/share/chezmoi/scripts/measure-shell-startup.sh [iterations]
```

## Testing

### Before Applying Changes
1. Run benchmark to establish baseline
2. Note current startup time

### After Applying Changes
1. Run `chezmoi apply`
2. Open new terminal
3. Run benchmark again
4. Compare results

### Verify Lazy Loading Works
```bash
# Open new shell
type kubectl  # Should show it's a function

# Use kubectl
kubectl version  # Triggers completion loading

type kubectl  # Should now show it's a real command
```

## Trade-offs

### Advantages
- Much faster perceived shell startup
- Commands still work identically
- Completions available when needed
- Backward compatible

### Considerations
- First use of each command has slight delay (one-time)
- Background jobs run after shell starts (minimal impact)
- SDKMAN/gcloud completion available after 0.1s delay

## Rollback

If issues occur, revert these files:
- `dot_completions`
- `dot_zshrc.tmpl` (sections: pyenv, gcloud, sdkman)
- `dot_bashrc.tmpl` (pyenv section)

Or use git to restore:
```bash
cd ~/.local/share/chezmoi
git checkout HEAD~1 -- dot_completions dot_zshrc.tmpl dot_bashrc.tmpl
chezmoi apply
```

## Future Optimizations

If further improvements needed:
1. Replace powerline-go with Starship (~50-100ms more)
2. Install zsh-defer plugin for more sophisticated deferral
3. Cache completion scripts to disk
4. Profile with `zprof` to identify remaining bottlenecks

## Notes

- Powerline-go kept as requested (not replaced with Starship)
- All changes are backward compatible
- Lazy-loading pattern can be applied to other tools if needed
- OrbStack completion not lazy-loaded (lightweight, always loaded)
