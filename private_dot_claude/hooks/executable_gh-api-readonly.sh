#!/bin/sh
# PreToolUse hook: allow only read-only (GET) gh api calls.
# Blocks POST, PUT, DELETE, PATCH and data-mutation flags.

input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // empty')

# Only check gh api commands
case "$command" in
  *"gh api"*) ;;
  *) exit 0 ;;
esac

# Block explicit write methods: -X POST, --method DELETE, etc.
if echo "$command" | grep -qEi '(\s|^)-X\s*(POST|PUT|DELETE|PATCH)|\s--method\s+(POST|PUT|DELETE|PATCH)'; then
  echo "Blocked: only read-only (GET) gh api calls are allowed" >&2
  exit 2
fi

# Block data flags that imply mutation (-d, -f, --raw-field, --field, --input)
if echo "$command" | grep -qE '\s(-d|--raw-field|-f|--field|--input)\s'; then
  echo "Blocked: data flags (-d, -f, --input) imply a write operation" >&2
  exit 2
fi

exit 0
