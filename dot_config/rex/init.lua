-- Rex keys, carried over from dot_tmux.conf. Prefix is still Ctrl-Space.
local function prefix(key, action, args)
  rex.bind("ctrl+space>" .. key, action, args)
end

-- Press prefix then a to send Ctrl-Space to the terminal
prefix("a", "pane.send_key", { key = "ctrl+space" })

-- split panes using | and -
-- | is Option-7 on the Swedish Mac layout
prefix("alt+7", "pane.split.right")
prefix("-", "pane.split.down")

-- new tabs always start in $HOME
rex.action{
  name  = "tab_home",
  title = "New Tab in Home",
  run   = function()
    rex.session.new_window{
      layout = rex.layout.block{
        flavor  = "com.superlogical.terminal.shell",
        options = { cwd = os.getenv("HOME") },
      },
    }
  end,
}
prefix("c", "tab_home")

prefix("r", "client.config.reload")

-- Send Ctrl-\ (0x1C, SIGQUIT / serial break), awkward on the Swedish Mac layout
prefix("shift+b", "pane.send_key", { key = "ctrl+\\" })

-- switch panes using Alt-arrow without prefix
rex.bind("alt+left", "pane.focus.left")
rex.bind("alt+right", "pane.focus.right")
rex.bind("alt+up", "pane.focus.up")
rex.bind("alt+down", "pane.focus.down")

-- tmux defaults the old config relied on
prefix("n", "client.tab.next")
prefix("p", "client.tab.previous")
prefix("z", "pane.zoom")
prefix("x", "pane.close")
prefix("s", "session.switch")
prefix(",", "client.tab.rename")
for i = 1, 9 do
  prefix(tostring(i), "client.tab.goto", { index = i })
end
