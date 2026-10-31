import QtQuick
import qs.common

// Thin bar on a faint track, filled to `progress` (0 to 1)
Item {
    id: root

    property real progress: 0

    height: Math.max(1, Sizes.px(2))

    Rectangle {
        anchors.fill: parent
        radius:       height / 2
        color:        Theme.track
    }

    // The gradient spans the whole track, so colors stay put as it fills
    Item {
        width:  Math.round(root.width * Math.max(0, Math.min(1, root.progress)))
        height: parent.height
        clip:   true

        Rectangle {
            width:  root.width
            height: root.height
            radius: height / 2

            gradient: Gradient {
                orientation: Gradient.Horizontal

                GradientStop { position: 0; color: Theme.accent }
                GradientStop { position: 1; color: Theme.accentAlt }
            }
        }
    }
}
