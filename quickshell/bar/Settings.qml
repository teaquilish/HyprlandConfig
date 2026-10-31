pragma Singleton

import QtQuick
import Quickshell

// Bar options. Defaults only for now, changing and saving them comes later.
Singleton {
    // "pacman" or "pill"
    readonly property string workspaceStyle:  "pacman"
    // Pacman workspace colors: "muted" or "arcade"
    readonly property string pacmanColors:    "muted"
    // Minutes idle before locking, 0 = never
    readonly property int    autoLockMinutes: 15
    // Size of the whole bar, 1 = 30 px tall islands
    readonly property real   barScale:        34 / 30
}
