import QtQuick
import Quickshell.Hyprland
import qs.common

// Workspaces 1-5, plus up to 10 when those are in use. Pac-Man (or the
// pill) sits on the workspace shown on this bar's monitor.
Item {
    id: root

    required property var screen

    readonly property int    spacing:  Sizes.slot
    readonly property var    monitor:  Hyprland.monitorFor(root.screen)
    readonly property int    activeId: monitor && monitor.activeWorkspace ? monitor.activeWorkspace.id : 0
    readonly property bool   pacman:   Settings.workspaceStyle === "pacman"
    readonly property real   targetX:  (activeId - 1) * spacing + spacing / 2

    // Normal workspaces 1-10 by id. Special ones have negative ids.
    readonly property var byId: {
        const map = {};
        for (const ws of Hyprland.workspaces.values) {
            if (ws.id >= 1 && ws.id <= 10)
                map[ws.id] = ws;
        }
        return map;
    }

    readonly property int slotCount: {
        let count = 5;
        for (let id = 6; id <= 10; id++) {
            const ws = byId[id];
            if (ws && (ws.active || ws.toplevels.values.length > 0))
                count = id;
        }
        return Math.max(count, Math.min(activeId, 10));
    }

    // The first jump to the active workspace shouldn't animate
    property bool placed:     false
    property real lastTarget: 0

    implicitWidth:  slotCount * spacing
    implicitHeight: spacing

    onTargetXChanged: {
        if (activeId < 1 || activeId > 10)
            return;
        if (placed)
            pacmanItem.facingLeft = targetX < lastTarget;
        else
            Qt.callLater(() => root.placed = true);
        lastTarget = targetX;
    }

    Component.onCompleted: {
        if (activeId >= 1 && activeId <= 10) {
            lastTarget = targetX;
            placed = true;
        }
    }

    function switchTo(id) {
        if (id === activeId)
            return;
        Hyprland.dispatch(Hyprland.usingLua ? `hl.dsp.focus({ workspace = ${id} })` : `workspace ${id}`);
    }

    Repeater {
        model: root.slotCount

        WorkspaceSlot {
            x:         index * root.spacing
            workspace: root.byId[index + 1] ?? null
            active:    index + 1 === root.activeId
            pacmanDx:  root.pacman ? pacmanItem.centerX - (x + width / 2) : 100
        }
    }

    PacMan {
        id: pacmanItem

        readonly property real centerX: x + width / 2

        visible:  root.pacman && root.activeId >= 1 && root.activeId <= 10
        x:        root.targetX - width / 2
        y:        (parent.height - height) / 2
        // Mouth is half open (smallest) on every slot center
        travel:   centerX - root.spacing / 2
        color:    Settings.pacmanColors === "arcade" ? Theme.yellow : Theme.text
        eyeColor: Theme.background

        Behavior on x {
            enabled: root.placed

            NumberAnimation {
                duration:    280
                easing.type: Easing.InOutQuad
            }
        }
    }

    // Stretches a little while it slides
    Rectangle {
        property real centerX: root.targetX

        visible: !root.pacman && root.activeId >= 1 && root.activeId <= 10
        x:       centerX - width / 2
        y:       (parent.height - height) / 2
        width:   Sizes.evenPx(30) + Math.min(Sizes.px(12), Math.abs(root.targetX - centerX) / 2)
        height:  Sizes.evenPx(10)
        radius:  height / 2

        gradient: Gradient {
            orientation: Gradient.Horizontal

            GradientStop { position: 0; color: Theme.accent }
            GradientStop { position: 1; color: Theme.accentAlt }
        }

        Behavior on centerX {
            enabled: root.placed

            NumberAnimation {
                duration:    280
                easing.type: Easing.InOutQuad
            }
        }
    }

    MouseArea {
        anchors.fill: parent

        // Touchpads send many small steps, so add them up to one notch
        property int wheelSum: 0

        onClicked: mouse => root.switchTo(Math.floor(mouse.x / root.spacing) + 1)

        onWheel: wheel => {
            wheelSum += wheel.angleDelta.y;
            if (Math.abs(wheelSum) < 120)
                return;
            const step = wheelSum > 0 ? -1 : 1;
            wheelSum = 0;
            const id = Math.max(1, Math.min(10, root.activeId + step));
            root.switchTo(id);
        }
    }
}
