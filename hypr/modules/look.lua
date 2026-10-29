-- Placeholder colors until the shared palette exists
local colors = {
    accent     = "rgba(89b4faee)",
    accent_alt = "rgba(cba6f7ee)",
    inactive   = "rgba(45475a88)",
    background = "rgb(11111b)",
}

hl.config({
    general = {
        layout           = "dwindle",
        gaps_in          = 4,
        gaps_out         = 8,
        border_size      = 2,
        resize_on_border = true,

        col = {
            active_border   = { colors = { colors.accent, colors.accent_alt }, angle = 45 },
            inactive_border = colors.inactive,
        },
    },

    decoration = {
        rounding       = 12,
        rounding_power = 2,

        blur = {
            enabled           = true,
            size              = 8,
            passes            = 2,
            new_optimizations = true,
            vibrancy          = 0.17,
            popups            = true,
        },

        shadow = {
            enabled = false,
        },
    },

    misc = {
        force_default_wallpaper  = 0,
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
        background_color         = colors.background,
    },
})
