#!/bin/bash
input=$(cat)

# ANSI color sequences
CYAN=$'\033[36m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
RED=$'\033[31m'
MAGENTA=$'\033[35m'
RESET=$'\033[0m'

# Extract values from Claude Code JSON
cwd=$(echo "$input" | jq -r '.cwd')
model=$(echo "$input" | jq -r '.model.display_name')
repo=$(echo "$input" | jq -r '.workspace.repo | if . then .owner + "/" + .name else empty end')
worktree_branch=$(echo "$input" | jq -r '.worktree.branch // .workspace.git_worktree // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
effort=$(echo "$input" | jq -r '.effort.level // empty')
session_name=$(echo "$input" | jq -r '.session_name // empty')

# Shorten CWD to max 4 path components (mirrors powerline-go -cwd-max-depth 4)
cwd_display=$(echo "$cwd" | sed "s|^$HOME|~|")
if echo "$cwd_display" | grep -qE '(/[^/]+){4,}'; then
    cwd_short=$(echo "$cwd_display" | rev | cut -d'/' -f1-3 | rev)
    cwd_display="…/$cwd_short"
fi

# CWD (cyan, like powerline-go cwd segment)
out="${CYAN}${cwd_display}${RESET}"

# Git repo + optional worktree branch (green, like powerline-go git segment)
if [ -n "$repo" ]; then
    git_display="$repo"
    [ -n "$worktree_branch" ] && git_display="${git_display}  ${worktree_branch}"
    out="${out}  ${GREEN}${git_display}${RESET}"
fi

# Session name (magenta, only when set via /rename)
if [ -n "$session_name" ]; then
    out="${out} | ${MAGENTA}${session_name}${RESET}"
fi

# Model name
out="${out} | ${model}"

# Effort level — only shown when it differs from the configured default (xhigh)
if [ -n "$effort" ] && [ "$effort" != "xhigh" ]; then
    out="${out} | ${YELLOW}effort:${effort}${RESET}"
fi

# Context window usage with traffic-light colouring
if [ -n "$used_pct" ]; then
    used_int=$(printf '%.0f' "$used_pct")
    if [ "$used_int" -ge 80 ]; then
        ctx_color="$RED"
    elif [ "$used_int" -ge 50 ]; then
        ctx_color="$YELLOW"
    else
        ctx_color="$GREEN"
    fi
    out="${out} | ${ctx_color}ctx:${used_int}%${RESET}"
fi

printf '%s\n' "$out"
