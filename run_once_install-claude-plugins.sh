#!/bin/bash
# Install Claude Code plugins declared in private_dot_claude/settings.json (enabledPlugins).
# Idempotent: marketplace-add and install are safe to re-run. Default modes set via dot_exports
# (CAVEMAN_DEFAULT_MODE / PONYTAIL_DEFAULT_MODE). Runs once; re-runs if this file changes.
set -euo pipefail

if ! command -v claude >/dev/null 2>&1; then
  echo "claude CLI not found; skipping plugin install"
  exit 0
fi

install_plugin() {
  local repo="$1" plugin="$2"
  claude plugin marketplace add "$repo" >/dev/null 2>&1 || true
  claude plugin install "$plugin" >/dev/null 2>&1 || true
  echo "ensured ${plugin}"
}

install_plugin JuliusBrussee/caveman caveman@caveman
install_plugin DietrichGebert/ponytail ponytail@ponytail
