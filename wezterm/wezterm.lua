-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Set the color scheme
function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return 'Catppuccin Mocha'
	else
		return 'Catppuccin Latte'
	end
end

wezterm.on("window-config-reloaded", function(window, _pane)
	local overrides = window:get_config_overrides() or {}
	local appearance = window:get_appearance()
	local scheme = scheme_for_appearance(appearance)
	if overrides.color_scheme ~= scheme then
		overrides.color_scheme = scheme
		window:set_config_overrides(overrides)
	end
end)

-- Set the font
config.font = wezterm.font {
	family = 'JetBrains Mono',
	harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }, -- Disable ligatures
}

config.font_size = 12.0
config.adjust_window_size_when_changing_font_size = false

-- Hide the tab bar
-- Multiplexing is handled by tmux
config.hide_tab_bar_if_only_one_tab = true

config.window_decorations = "RESIZE"
config.window_padding = {
	left = '1cell',
	right = '1cell',
	top = '0.5cell',
	-- bottom = '0.5cell',
}

-- Performance
config.max_fps = 250

return config
