#!/bin/sh
# PreToolUse hook: prompt user for approval on write gh api calls.
# Read-only calls pass through; writes trigger a user confirmation prompt.

input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // empty')

# Only check gh api commands
case "$command" in
  *"gh api"*) ;;
  *) exit 0 ;;
esac

reason=""

# Detect explicit write methods: -X POST, --method DELETE, etc.
if echo "$command" | grep -qEi '(\s|^)-X\s*(POST|PUT|DELETE|PATCH)|\s--method\s+(POST|PUT|DELETE|PATCH)'; then
  reason="GitHub API write operation detected"
fi

# Detect data flags that imply mutation (-d, -f, --raw-field, --field, --input)
if [ -z "$reason" ] && echo "$command" | grep -qE '\s(-d|--raw-field|-f|--field|--input)\s'; then
  reason="GitHub API data flags detected (implies write operation)"
fi

# No write indicators found — allow
[ -z "$reason" ] && exit 0

# Prompt user for approval instead of hard-blocking
cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "ask",
    "permissionDecisionReason": "$reason"
  }
}
EOF
exit 0
