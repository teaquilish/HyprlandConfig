import QtQuick
import qs.common

// One workspace in the row: pellet, ghost or scared ghost (pacman style),
// or a dot (pill style). The active workspace is drawn by Workspaces.qml.
Item {
    id: root

    required property int index
    property var  workspace:  null
    property bool active:     false
    // Pac-Man's center, relative to this slot's center
    property real pacmanDx:   0

    readonly property bool occupied: workspace !== null && workspace.toplevels.values.length > 0
    readonly property bool urgent:   !active && ((workspace !== null && workspace.urgent) || Alerts.belled[index + 1] !== undefined)
    readonly property bool pacman:   Settings.workspaceStyle === "pacman"
    readonly property bool arcade:   Settings.pacmanColors === "arcade"
    // Hidden while Pac-Man is on top of it
    readonly property bool covered:  pacman && Math.abs(pacmanDx) < Sizes.scale * 8

    readonly property var arcadeGhosts: [Theme.arcadeRed, Theme.arcadePink, Theme.arcadeCyan, Theme.arcadeOrange]

    width:  Sizes.slot
    height: Sizes.slot

    // Fades in when the row grows
    opacity: 0
    Component.onCompleted: opacity = 1

    Behavior on opacity { NumberAnimation { duration: 250 } }

    Rectangle {
        anchors.centerIn: parent
        visible: !root.pacman ? !root.active
               :                !root.covered && !root.occupied && !root.urgent
        width:   root.pacman ? Sizes.px(5) : Sizes.evenPx(6)
        height:  width
        radius:  width / 2
        color:   root.pacman            ? Theme.surface
               : root.urgent            ? Theme.accentAlt
               : root.occupied          ? Theme.subtext
               :                          Theme.muted
    }

    Ghost {
        anchors.centerIn: parent
        visible:    root.pacman && !root.covered && (root.occupied || root.urgent)
        scared:     root.urgent
        lookLeft:   root.pacmanDx < 0
        color:      root.arcade ? root.arcadeGhosts[root.index % 4] : Theme.muted
        pupilColor: root.arcade ? Theme.arcadeBlue : Theme.background
    }
}
