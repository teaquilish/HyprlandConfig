import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.common

// One screen's bar: a transparent strip with three floating islands
PanelWindow {
    id: root

    required property var modelData

    screen: modelData
    color:  "transparent"

    anchors {
        top:   true
        left:  true
        right: true
    }

    // Extra room under the islands so the shadow isn't cut off
    implicitHeight: Theme.barGap + Theme.barHeight + 8

    // Reserve only the gap and the islands. Hyprland adds gaps_out on top,
    // so windows start 8 px below the islands.
    exclusiveZone: Theme.barGap + Theme.barHeight

    WlrLayershell.namespace: "bar"

    // Clicks outside the islands go through to the windows below
    mask: Region {
        Region { item: leftIsland }
        Region { item: centerIsland }
        Region { item: rightIsland }
    }

    Island {
        id: leftIsland
        x:     Theme.barGap
        width: 246
    }

    Island {
        id: centerIsland
        x:     (parent.width - width) / 2
        width: 312
    }

    Island {
        id: rightIsland
        x:     parent.width - width - Theme.barGap
        width: 388
    }
}
