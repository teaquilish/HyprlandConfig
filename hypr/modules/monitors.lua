hl.monitor({
    output   = "DP-2",
    mode     = "2560x1440@200",
    position = "0x0",
    scale    = 1,
})

-- Any other screen (a new monitor, or the nested test window)
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})
