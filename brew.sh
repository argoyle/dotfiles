#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Make sure we're using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

for tap in $(cat brew-taps)
do
  brew tap ${tap}
done

brew install $(< brew-packages)

brew cask install $(< brew-cask-packages)

# Remove outdated versions from the cellar.
brew cleanup

brew link --force gettext

