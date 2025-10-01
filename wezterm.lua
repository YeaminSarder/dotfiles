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
config.leader = { key = 'h', mods = 'CTRL', timeout_milliseconds = 5000 }

--- panes
-- split pane
map(config, 'LEADER|CTRL-h' , wezterm.action.SendKey { key = 'h', mods = 'CTRL' })
map(config, 'LEADER|ALT-f'  , wezterm.action.SplitPane{ direction = 'Right'})
map(config, 'LEADER|ALT-b'  , wezterm.action.SplitPane{ direction = 'Left' })
map(config, 'LEADER|ALT-n'  , wezterm.action.SplitPane{ direction = 'Down' })
map(config, 'LEADER|ALT-p'  , wezterm.action.SplitPane{ direction = 'Up'   })
map(config, 'LEADER|ALT-F'  , wezterm.action.SplitPane{ direction = 'Right', top_level = true })
map(config, 'LEADER|ALT-B'  , wezterm.action.SplitPane{ direction = 'Left' , top_level = true })
map(config, 'LEADER|ALT-N'  , wezterm.action.SplitPane{ direction = 'Down' , top_level = true })
map(config, 'LEADER|ALT-P'  , wezterm.action.SplitPane{ direction = 'Up'   , top_level = true })

map(config, 'LEADER-x'  , wezterm.action.CloseCurrentPane{ confirm = true })

-- activate pane
map(config, 'LEADER|CTRL-f'  , wezterm.action.ActivatePaneDirection 'Right')
map(config, 'LEADER|CTRL-b'  , wezterm.action.ActivatePaneDirection 'Left' )
map(config, 'LEADER|CTRL-n'  , wezterm.action.ActivatePaneDirection 'Down' )
map(config, 'LEADER|CTRL-p'  , wezterm.action.ActivatePaneDirection 'Up'   )

map(config, 'LEADER|CTRL-s'  , wezterm.action.PaneSelect {alphabet = 'aoeuhtns'}  )
map(config, 'LEADER|ALT-s'   , wezterm.action.PaneSelect { alphabet = 'aoeuhtns', mode = 'SwapWithActive' })
map(config, 'LEADER-S'       , wezterm.action.PaneSelect {alphabet = 'aoeuhtns', mode = 'MoveToNewTab'}  )

map(config, 'LEADER-z', wezterm.action.TogglePaneZoomState)

map(config, 'LEADER-:', act.ActivateCommandPalette)

-- resize pane
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

---- tabs
map(config, 'LEADER-f', act.ActivateTabRelative(1))
map(config, 'LEADER-b', act.ActivateTabRelative(-1))
map(config, 'LEADER-l', act.ActivateLastTab)



return config
