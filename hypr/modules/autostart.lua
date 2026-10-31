hl.on("hyprland.start", function()
    -- Wallpaper (reads hyprpaper.conf next to hyprland.lua)
    hl.exec_cmd("hyprpaper")

    -- Idle: lock and screen off (reads hypridle.conf next to hyprland.lua)
    hl.exec_cmd("hypridle")

    -- Clipboard history for SUPER + C
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- Audio effects, in the background with my EQ preset
    hl.exec_cmd("easyeffects --service-mode --hide-window --load-preset live_eq")

    -- Password popups for apps that need admin rights
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
end)
