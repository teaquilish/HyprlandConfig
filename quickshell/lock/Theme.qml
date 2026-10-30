pragma Singleton

import QtQuick
import Quickshell

// Placeholder colors until the shared palette exists (same as look.lua)
Singleton {
    readonly property color background: "#11111b"
    readonly property color text:       "#cdd6f4"
    readonly property color subtext:    "#a6adc8"
    readonly property color accent:     "#89b4fa"
    readonly property color accentAlt:  "#cba6f7"
    readonly property color red:        "#f38ba8"
    readonly property color yellow:     "#f9e2af"

    // Frosted panels: clock face, time, password box
    readonly property color glass:       Qt.rgba(0.07, 0.07, 0.11, 0.45)
    readonly property color glassBorder: Qt.rgba(1, 1, 1, 0.18)

    readonly property string font:  "Google Sans"
    readonly property string icons: "JetBrainsMono Nerd Font"

    readonly property string wallpaper: Quickshell.env("HOME") + "/Pictures/Wallpapers/ddg_1785828979958051735.jpg"
}
