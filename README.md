# Dotfiles

## Setup on new computer

### Xcode command line tools

```bash
xcode-select --install
````

### Rosetta

```bash
sudo softwareupdate --install-rosetta
```

### Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Chezmoi

```bash
brew install chezmoi
brew install lastpass-cli
lpass login joakim@unbound.se
```

```bash
chezmoi init --apply argoyle
```

## Sync files

### Cleanup on old machine

```bash
find Source -type d -name node_modules | xargs rm -rf
find Source -type d -name .terraform | xargs rm -rf
find Source -type d -name .direnv | xargs rm -rf
```

Also remove configuration for old version of JetBrains tools in `~/Library/Application Support/JetBrains`

### Rsync from new machine

Enable SSH-access (System Settings - General - Sharing - Remote Login) on old machine and then do:

```bash
for dir in Desktop Documents Movies Music Pictures Source "Library/Application Support/Arc" "Library/Application Support/JetBrains" .local/share/tmux ; do rsync -azPp argoyle@<old ip>:"$dir/" "$dir"; done;
for file in "Library/Preferences/company.thebrowser.Browser.plist" .zsh_history ; do rsync -azPp argoyle@<old ip>:"$file" "$file"; done;
```

## After syncing

Install Tmux plugins by pressing `Ctrl-space I` (capital i) and then reload configuration by
executing `tmux source-file ~/.tmux.conf`.
Restoring last tmux environment can be done using `Ctrl-space Ctrl-r`.
