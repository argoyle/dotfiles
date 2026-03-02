#!/bin/sh
# PreToolUse hook: block `but pr` on Gitea-hosted repos.

input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // empty')

# Only check but pr commands
case "$command" in
  *"but pr"*|*"but "*"pr "*) ;;
  *) exit 0 ;;
esac

# Extract repo path from -C flag, fall back to cwd
repo_path="."
case "$command" in
  *"-C "*)
    repo_path=$(echo "$command" | sed 's/.*-C  *//' | sed 's/ .*//')
    ;;
esac

origin_url=$(git -C "$repo_path" remote get-url origin 2>/dev/null || echo "")
case "$origin_url" in
  *git.unbound.se*|*git.nl.cloud*)
    echo "Blocked: 'but pr' does not support Gitea ($origin_url). Use the Gitea REST API instead." >&2
    exit 2
    ;;
esac
exit 0
