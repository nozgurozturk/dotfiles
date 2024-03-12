-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Set the color scheme
config.color_scheme = 'Catppuccin Mocha'

-- Set the font
-- config.font = wezterm.font 'JetBrainsMono Nerd Font Mono'
config.font = wezterm.font {
  family = 'JetBrains Mono',
  harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }, -- Disable ligatures
}

config.font_size = 13.0
config.adjust_window_size_when_changing_font_size = false

-- Hide the tab bar
-- Multiplexing is handled by tmux
config.hide_tab_bar_if_only_one_tab = true

config.window_decorations = "RESIZE"
config.window_padding = {
  left = '1cell',
  right = '1cell',
  top = '0.5cell',
  bottom = '0.5cell',
}

return config
