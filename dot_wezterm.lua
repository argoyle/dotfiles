-- Pull in the wezterm API
local wezterm = require 'wezterm'

local mux = wezterm.mux

-- This table will hold the configuration.
local config = {}

wezterm.on('gui-startup', function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
--config.color_scheme = 'Afterglow'
--config.color_scheme = 'Breeze'
--config.color_scheme = 'Deep'
--config.color_scheme = 'Dracula+'
--config.color_scheme = 'GitHub Dark'
--config.color_scheme = 'Gruvbox Dark Hard'
--config.color_scheme = 'Higway'
--config.color_scheme = 'Hurtado'
--config.color_scheme = 'iTerm2 Tango Dark'
--config.color_scheme = 'Monokai Remastered'
--config.color_scheme = 'Monokai Vivid'
--config.color_scheme = 'Smyck'
config.color_scheme = 'Dimidum'

config.font = wezterm.font 'CommitMono'
config.font_size = 15

config.hide_tab_bar_if_only_one_tab = true

-- and finally, return the configuration to wezterm
return config
