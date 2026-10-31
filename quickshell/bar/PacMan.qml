import QtQuick
import QtQuick.Shapes
import qs.common

// Pac-Man facing right. The mouth follows `travel`, so he chomps only
// while his position animates and nothing runs when he stands still.
Item {
    id: root

    property color color:       Theme.text
    property color eyeColor:    Theme.background
    property real  travel:      0
    // Pixels moved per open-close of the mouth
    property real  chompLength: Sizes.slot / 2
    property bool  facingLeft:  false

    // Half the mouth opening, in degrees
    readonly property real mouth: 4 + 36 * Math.abs(Math.sin(travel * Math.PI / chompLength + 0.5))

    width:  Sizes.evenPx(16)
    height: Sizes.evenPx(16)

    transform: Scale {
        origin.x: root.width / 2
        xScale:   root.facingLeft ? -1 : 1
    }

    // Drawn on a 16 px grid, then stretched to the real size
    Item {
        width:  16
        height: 16

        transform: Scale {
            xScale: root.width / 16
            yScale: root.height / 16
        }

        Shape {
            anchors.fill:          parent
            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                fillColor:   root.color
                strokeColor: "transparent"
                startX:      8
                startY:      8

                PathAngleArc {
                    centerX:     8
                    centerY:     8
                    radiusX:     8
                    radiusY:     8
                    startAngle:  root.mouth
                    sweepAngle:  360 - 2 * root.mouth
                    moveToStart: false
                }

                PathLine { x: 8; y: 8 }
            }
        }

        Rectangle {
            x:      8
            y:      3
            width:  2.5
            height: 2.5
            radius: width / 2
            color:  root.eyeColor
        }
    }
}
