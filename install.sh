#!/usr/bin/env bash

# Install brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Passwordless sudo
echo "$(whoami)            ALL = (ALL) NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/$(whoami)"

# Install applications
./brew.sh
./zsh.sh
./macos.sh gwaihir

# Symlink dot-files
for file in .*; do
	[ -r "$file" ] && [ -f "$file" ] && ln -fs "$(pwd {BASH_SOURCE[0]})/$file" ~/$file;
done

# Post installation
# iTerm2
ln -s "$(pwd {BASH_SOURCE[0]})/iterm2/profiles.json ~/Library/Application\ Support/iTerm2/DynamicProfiles/profiles.json


echo "Reboot :)"
