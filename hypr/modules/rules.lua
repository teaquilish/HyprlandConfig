-- Apps can't maximize themselves and break the tiling
hl.window_rule({
    name           = "no-maximize",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

-- Invisible XWayland helper windows steal focus while dragging
hl.window_rule({
    name     = "xwayland-drag-fix",
    match    = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true,
})

-- Small tool windows: float in the middle of the screen
local floating = {
    { class = "^(org.pulseaudio.pavucontrol)$" },
    { class = "^(org.kde.polkit-kde-authentication-agent-1)$" },
    { class = "^(xdg-desktop-portal-gtk)$" },
    { title = "^(Open File|Open Folder|Save As|Save File|File Upload).*" },
    { modal = true },
}

for _, match in ipairs(floating) do
    hl.window_rule({ match = match, float = true, center = true })
end

-- Picture-in-picture video: small, on top, on every workspace
hl.window_rule({
    name  = "pip",
    match = { title = "^(Picture-in-Picture)$" },
    float = true,
    pin   = true,
    size  = { "monitor_w * 0.25", "monitor_h * 0.25" },
    move  = { "monitor_w * 0.74", "monitor_h * 0.73" },
})
