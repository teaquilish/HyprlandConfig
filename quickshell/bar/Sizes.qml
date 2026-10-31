pragma Singleton

import QtQuick
import Quickshell
import qs.common

// Bar sizes after Settings.barScale. Base numbers are the 1.0 look; px()
// scales one and rounds it to whole pixels, evenPx() to an even number so
// things centered in each other stay on whole pixels. The top gap doesn't
// scale.
Singleton {
    readonly property real scale:        Settings.barScale
    readonly property int  gap:          Theme.barGap
    readonly property int  barHeight:    evenPx(Theme.barHeight)
    readonly property int  islandRadius: Math.round(barHeight / 2)
    // Width of one workspace slot
    readonly property int  slot:         evenPx(22)

    function px(n) {
        return Math.round(n * scale);
    }

    function evenPx(n) {
        return 2 * Math.round(n * scale / 2);
    }
}
