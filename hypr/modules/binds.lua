local mod      = "SUPER"
local terminal = "kitty"

local function bind(keys, action, opts)
    hl.bind(mod .. " + " .. keys, action, opts)
end

local media = { locked = true }
local held  = { locked = true, repeating = true }

-- Apps
bind("RETURN", hl.dsp.exec_cmd(terminal))
bind("F",      hl.dsp.exec_cmd("zen-browser"))
bind("E",      hl.dsp.exec_cmd("dolphin"))
bind("D",      hl.dsp.exec_cmd("fuzzel"))
bind("C",      hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"))
bind("V",      hl.dsp.exec_cmd("pavucontrol"))
bind("R",      hl.dsp.reload_config())

-- Windows
bind("Q",         hl.dsp.window.close())
bind("T",         hl.dsp.window.float({ action = "toggle" }))
bind("mouse:272", hl.dsp.window.drag(),   { mouse = true })
bind("mouse:273", hl.dsp.window.resize(), { mouse = true })

local directions = { Left = "left", Right = "right", Up = "up", Down = "down" }
local resize     = { Left = { -50, 0 }, Right = { 50, 0 }, Up = { 0, -50 }, Down = { 0, 50 } }

for key, dir in pairs(directions) do
    bind(key,            hl.dsp.focus({ direction = dir }))
    bind("CTRL + " .. key, hl.dsp.window.move({ direction = dir:sub(1, 1) }))
    bind("SHIFT + " .. key, hl.dsp.window.resize({ x = resize[key][1], y = resize[key][2], relative = true }),
        { repeating = true })
end

-- Workspaces: SUPER + 1..0 to switch, SUPER + SHIFT + 1..0 to move the window there
for i = 1, 10 do
    local key = tostring(i % 10)
    bind(key,              hl.dsp.focus({ workspace = i }))
    bind("SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Media
bind("SPACE", hl.dsp.exec_cmd("playerctl play-pause"), media)
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), media)
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), media)
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   media)
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       media)

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), held)
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      held)
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     media)
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   media)

-- Lock (handled by hypridle + hyprlock once they're set up in Phase 2)
bind("L", hl.dsp.exec_cmd("loginctl lock-session"), media)
hl.bind("XF86PowerOff", hl.dsp.exec_cmd("loginctl lock-session"), media)

-- Screenshots: S = area, F = full screen, C / G = same but open in the editor
local shot = "~/Pictures/Screenshots/$(date +%F_%H-%M-%S).png"
local area = [[geom=$(slurp) && grim -g "$geom" -]]
local full = "grim -"
local save = " | tee " .. shot .. " | wl-copy"
local edit = " | satty --filename - --copy-command wl-copy --output-filename ~/Pictures/Screenshots/%F_%H-%M-%S.png"

bind("SHIFT + S", hl.dsp.exec_cmd(area .. save))
bind("SHIFT + F", hl.dsp.exec_cmd(full .. save))
bind("SHIFT + C", hl.dsp.exec_cmd(area .. edit))
bind("SHIFT + G", hl.dsp.exec_cmd(full .. edit))

-- Screen recording: R = full screen, T = area, X = stop
local video = "~/Videos/recording-$(date +%Y%m%d-%H%M%S).mp4"

bind("SHIFT + R", hl.dsp.exec_cmd("wf-recorder -f " .. video))
bind("SHIFT + T", hl.dsp.exec_cmd([[wf-recorder -g "$(slurp)" -f ]] .. video))
bind("SHIFT + X", hl.dsp.exec_cmd("pkill -SIGINT wf-recorder"))
