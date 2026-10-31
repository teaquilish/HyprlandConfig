pragma Singleton

import QtQuick
import Quickshell

// The bar's only clock, shared by every screen. Ticks once a second.
Singleton {
    readonly property date date:    clock.date
    readonly property int  hours:   clock.hours
    readonly property int  minutes: clock.minutes
    readonly property int  seconds: clock.seconds
    // Part of the day gone by, 0 at 00:00 and 1 at 24:00
    readonly property real dayProgress: (hours * 3600 + minutes * 60 + seconds) / 86400

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
