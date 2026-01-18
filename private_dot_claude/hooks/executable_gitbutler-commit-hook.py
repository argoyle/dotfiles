#!/usr/bin/env python3
"""
PreToolUse hook that intercepts git commands when on gitbutler/workspace branch
and replaces them with equivalent 'but' CLI commands.
"""
import json
import sys
import subprocess


def get_current_branch():
    try:
        return subprocess.check_output(
            ["git", "branch", "--show-current"],
            text=True, stderr=subprocess.DEVNULL
        ).strip()
    except Exception:
        return None


def main():
    try:
        input_data = json.load(sys.stdin)
    except json.JSONDecodeError:
        sys.exit(0)

    tool_name = input_data.get("tool_name", "")
    tool_input = input_data.get("tool_input", {})
    command = tool_input.get("command", "")

    # Only intercept Bash tool with git commands
    if tool_name != "Bash":
        sys.exit(0)

    # Check if on gitbutler/workspace branch
    current_branch = get_current_branch()
    if current_branch != "gitbutler/workspace":
        sys.exit(0)

    modified_command = None

    # Map git commands to but equivalents
    if command.startswith("git commit"):
        modified_command = command.replace("git commit", "but commit", 1)
    elif command.startswith("git add") and "&&" in command and "git commit" in command:
        # Handle "git add . && git commit" patterns
        modified_command = command.replace("git commit", "but commit")
    elif command.startswith("git status"):
        modified_command = command.replace("git status", "but status", 1)

    if modified_command:
        output = {
            "hookSpecificOutput": {
                "hookEventName": "PreToolUse",
                "permissionDecision": "allow",
                "permissionDecisionReason": "On gitbutler/workspace: using 'but' CLI",
                "updatedInput": {"command": modified_command}
            }
        }
        print(json.dumps(output))

    sys.exit(0)


if __name__ == "__main__":
    main()
