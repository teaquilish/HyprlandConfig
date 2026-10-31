import QtQuick
import QtQuick.Effects
import qs.common

// Arch logo in a gradient circle
Item {
    width:  Sizes.evenPx(20)
    height: Sizes.evenPx(20)

    RectangularShadow {
        anchors.fill: parent
        radius:       width / 2
        blur:         Sizes.px(5)
        color:        Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.35)
    }

    // A vertical gradient turned by -45° runs from top-left to bottom-right
    Rectangle {
        anchors.fill: parent
        radius:       width / 2
        rotation:     -45

        gradient: Gradient {
            GradientStop { position: 0; color: Theme.accent }
            GradientStop { position: 1; color: Theme.accentAlt }
        }
    }

    Text {
        anchors.centerIn: parent
        text:           "\uf303"
        color:          Theme.background
        font.family:    Theme.icons
        font.pixelSize: Sizes.px(13)
    }
}
