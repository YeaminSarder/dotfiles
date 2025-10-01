-- Pull in the wezterm API
local wezterm = require 'wezterm'
local keymapper = (require 'keymapper')
local map = keymapper.map
local act = wezterm.action
-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 160
config.initial_rows = 50

-- or, changing the font size and color scheme.
config.font_size = 11
config.color_scheme = 'GitHub'--'AdventureTime'
config.force_reverse_video_cursor = true

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.window_background_opacity = 0.25
config.text_background_opacity = 0.5
config.macos_window_background_blur = 25

config.pane_focus_follows_mouse = true




-- Show which key table is active in the status area
wezterm.on('update-right-status', function(window, pane)
   local name = window:active_key_table()
   if name then
      name = 'TABLE: ' .. name
   end
   window:set_right_status(name or '')
end)



-- timeout_milliseconds defaults to 1000 and can be omitted
config.leader = { key = 'h', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
   { key = 'h', mods = 'LEADER|CTRL', action = wezterm.action.SendKey { key = 'h', mods = 'CTRL' }, },
   -- splitting
   { key = 'f', mods = 'LEADER|ALT',  action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }, },
   { key = 'b', mods = 'LEADER|ALT',  action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }, },
   { key = 'n', mods = 'LEADER|ALT',  action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' }, },
   { key = 'p', mods = 'LEADER|ALT',  action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }, },

   -- { key = 'r', mods = 'LEADER',      action = act.ActivateKeyTable { name = 'resize_pane', one_shot = false, }, },
}



map(config, 'LEADER-r*>p', act.AdjustPaneSize { 'Up', 4 })
map(config, 'LEADER-r*>n', act.AdjustPaneSize { 'Down', 4 })
map(config, 'LEADER-r*>f', act.AdjustPaneSize { 'Right', 4 })
map(config, 'LEADER-r*>b', act.AdjustPaneSize { 'Left', 4 })
map(config, 'LEADER-r*>CTRL-p', act.AdjustPaneSize { 'Up', 1 })
map(config, 'LEADER-r*>CTRL-n', act.AdjustPaneSize { 'Down', 1 })
map(config, 'LEADER-r*>CTRL-f', act.AdjustPaneSize { 'Right', 1 })
map(config, 'LEADER-r*>CTRL-b', act.AdjustPaneSize { 'Left', 1 })
map(config, 'LEADER-r*>Escape', 'PopKeyTable')
map(config, 'LEADER-r*>Space', 'PopKeyTable')
return config
