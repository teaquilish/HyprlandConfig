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
    implicitHeight: Sizes.gap + Sizes.barHeight + Sizes.px(8)

    // Reserve only the gap and the islands. Hyprland adds gaps_out on top,
    // so windows start 8 px below the islands.
    exclusiveZone: Sizes.gap + Sizes.barHeight

    WlrLayershell.namespace: "bar"

    // Clicks outside the islands go through to the windows below
    mask: Region {
        Region { item: leftIsland }
        Region { item: centerIsland }
        Region { item: rightIsland }
    }

    Island {
        id: leftIsland
        x:     Sizes.gap
        width: Sizes.px(5) + archLogo.width + Sizes.px(6) + workspaces.implicitWidth + Sizes.px(6)

        Behavior on width {
            NumberAnimation {
                duration:    250
                easing.type: Easing.OutCubic
            }
        }

        // Hides a new slot until the island has grown around it
        Item {
            anchors.fill: parent
            clip:         true

            ArchLogo {
                id: archLogo
                x: Sizes.px(5)
                anchors.verticalCenter: parent.verticalCenter
            }

            Workspaces {
                id: workspaces
                x:      archLogo.x + archLogo.width + Sizes.px(6)
                screen: root.modelData
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    Island {
        id: centerIsland
        x:     Math.round((parent.width - width) / 2)
        width: 2 * Sizes.px(10) + Math.ceil(centerRow.implicitWidth)

        Behavior on width {
            NumberAnimation {
                duration:    250
                easing.type: Easing.OutCubic
            }
        }

        Item {
            anchors.fill: parent
            clip:         true

            // Sits a pixel high to leave room for the day line
            Row {
                id: centerRow
                x:       Sizes.px(10)
                spacing: Sizes.px(10)
                anchors.verticalCenter:       parent.verticalCenter
                anchors.verticalCenterOffset: -Sizes.px(1)

                Clock {
                    anchors.verticalCenter: parent.verticalCenter
                }

                DateLabel {
                    anchors.verticalCenter: parent.verticalCenter
                }

                // Weather goes here
            }

            // Inset by the corner radius so it stays inside the rounded edge
            DayLine {
                x:        Sizes.islandRadius
                y:        parent.height - height - Sizes.px(2)
                width:    parent.width - 2 * Sizes.islandRadius
                progress: Time.dayProgress
            }
        }
    }

    Island {
        id: rightIsland
        x:     parent.width - width - Sizes.gap
        width: Sizes.px(388)
    }
}
