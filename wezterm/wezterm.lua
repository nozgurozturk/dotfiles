-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Set the color scheme
config.color_scheme = 'Catppuccin Mocha'

-- Set the font
-- config.font = wezterm.font 'JetBrainsMono Nerd Font Mono'
config.font_size = 13.0
config.adjust_window_size_when_changing_font_size = false

-- Hide the tab bar
-- Multiplexing is handled by tmux
config.enable_tab_bar = false

config.window_decorations = "RESIZE"
config.window_padding = {
    left = '1cell',
    right = '1cell',
    top = '0.5cell',
    bottom = '0.5cell',
}

return config
