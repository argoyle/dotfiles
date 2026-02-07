#!/bin/sh
# Claude Code hook: send tmux notifications on Stop and Notification events
# Triggers a bell so monitor-bell highlights the window in the status bar

# Only notify if inside a tmux session
[ -z "$TMUX" ] && exit 0

event=$(cat | jq -r '.hook_event_name // empty')

case "$event" in
    Stop)
        tmux display-message "Claude finished responding"
        printf '\a'
        ;;
    Notification)
        tmux display-message "Claude is waiting for input"
        printf '\a'
        ;;
esac

exit 0
