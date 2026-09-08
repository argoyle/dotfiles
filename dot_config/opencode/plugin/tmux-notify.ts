import { appendFileSync } from "node:fs"
import type { Plugin } from "@opencode-ai/plugin"

// Ring the bell on the opencode pane's tty so tmux monitor-bell flags the window.
// Mirrors ~/.claude/hooks/tmux-notify.sh (Stop / StopFailure / Notification).
export const TmuxNotify: Plugin = async ({ $ }) => {
  const pane = process.env["TMUX_PANE"]
  if (!process.env["TMUX"] || !pane) return {}

  const tty = (await $`tmux display-message -p -t ${pane} '#{pane_tty}'`.text()).trim()
  if (!tty) return {}

  return {
    event: async ({ event }) => {
      switch (event.type) {
        case "session.idle":
        case "session.error":
        case "permission.updated":
          try {
            appendFileSync(tty, "\x07")
          } catch {
            // pane is gone; nothing to notify
          }
      }
    },
  }
}
