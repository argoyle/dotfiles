#!/bin/sh
# PreToolUse hook: block `pre-commit run` when no .pre-commit-config.yaml exists.

input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // empty')

# Only check pre-commit run commands
case "$command" in
  *"pre-commit run"*) ;;
  *) exit 0 ;;
esac

# Extract repo path from -C flag or git add -C, fall back to cwd
repo_path="."
case "$command" in
  *"-C "*)
    repo_path=$(echo "$command" | sed 's/.*-C  *//' | sed 's/ .*//')
    ;;
esac

# Resolve to git root if possible
git_root=$(git -C "$repo_path" rev-parse --show-toplevel 2>/dev/null || echo "$repo_path")

if [ ! -f "$git_root/.pre-commit-config.yaml" ]; then
  echo "Blocked: no .pre-commit-config.yaml found in $git_root. Skipping pre-commit." >&2
  exit 2
fi
exit 0
