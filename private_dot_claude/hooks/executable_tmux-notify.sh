#!/bin/sh
# Claude Code hook: send tmux notifications on Stop and Notification events
# Sends bell to the Claude pane's tty so monitor-bell flags the window

# Only notify if inside a tmux session
[ -z "$TMUX" ] && exit 0
[ -z "$TMUX_PANE" ] && exit 0

# Get the tty of the pane running Claude
pane_tty=$(tmux display-message -p -t "$TMUX_PANE" '#{pane_tty}')
[ -z "$pane_tty" ] && exit 0

event=$(cat | jq -r '.hook_event_name // empty')

case "$event" in
    Stop)
        tmux display-message -t "$TMUX_PANE" "Claude finished responding"
        printf '\a' > "$pane_tty"
        ;;
    Notification)
        tmux display-message -t "$TMUX_PANE" "Claude is waiting for input"
        printf '\a' > "$pane_tty"
        ;;
esac

exit 0
