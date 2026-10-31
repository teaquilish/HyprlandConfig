import QtQuick
import QtQuick.Effects
import qs.common

// Rounded block the bar's widgets sit in
Rectangle {
    y:            Sizes.gap
    height:       Sizes.barHeight
    radius:       Sizes.islandRadius
    color:        Theme.island
    border.width: 1
    border.color: Theme.islandBorder

    // Negative z draws it under the island
    RectangularShadow {
        anchors.fill: parent
        z:            -1
        radius:       parent.radius
        offset.y:     Sizes.px(2)
        blur:         Sizes.px(8)
        color:        Theme.shadow
    }
}
