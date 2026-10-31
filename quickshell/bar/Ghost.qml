import QtQuick
import QtQuick.Effects
import QtQuick.Shapes
import qs.common

// Ghost with a round top and three wavy feet. Scared: glowing body and a
// dark face with square eyes and a zigzag mouth.
Item {
    id: root

    property color color:      Theme.muted
    property color pupilColor: Theme.background
    property bool  lookLeft:   false
    property bool  scared:     false

    width:  14
    height: 14

    RectangularShadow {
        anchors.fill: parent
        visible:      root.scared
        radius:       7
        blur:         6
        color:        Qt.rgba(Theme.accentAlt.r, Theme.accentAlt.g, Theme.accentAlt.b, 0.6)
    }

    Shape {
        anchors.fill:          parent
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            fillColor:   root.scared ? Theme.accentAlt : root.color
            strokeColor: "transparent"
            startX:      0
            startY:      12.5

            PathLine { x: 0; y: 7 }
            PathArc  { x: 14; y: 7; radiusX: 7; radiusY: 7 }
            PathLine { x: 14; y: 12.5 }
            PathArc  { x: 28 / 3; y: 12.5; radiusX: 7 / 3; radiusY: 1.5 }
            PathArc  { x: 14 / 3; y: 12.5; radiusX: 7 / 3; radiusY: 1.5 }
            PathArc  { x: 0;      y: 12.5; radiusX: 7 / 3; radiusY: 1.5 }
        }
    }

    // Normal face: white eyes, pupils look towards Pac-Man
    Repeater {
        model: root.scared ? 0 : 2

        Rectangle {
            required property int index

            x:      2.2 + index * 5.6
            y:      3.5
            width:  4
            height: 5
            radius: 2
            color:  "white"

            Rectangle {
                x:      root.lookLeft ? 0.2 : 1.8
                y:      2
                width:  2
                height: 2
                radius: 1
                color:  root.pupilColor
            }
        }
    }

    // Scared face
    Repeater {
        model: root.scared ? 2 : 0

        Rectangle {
            required property int index

            x:      3.5 + index * 5
            y:      5
            width:  2
            height: 2
            color:  Theme.background
        }
    }

    Shape {
        anchors.fill:          parent
        visible:               root.scared
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            fillColor:   "transparent"
            strokeColor: Theme.background
            strokeWidth: 1

            PathPolyline {
                path: [
                    Qt.point(2.5, 10), Qt.point(4, 9), Qt.point(5.5, 10), Qt.point(7, 9),
                    Qt.point(8.5, 10), Qt.point(10, 9), Qt.point(11.5, 10)
                ]
            }
        }
    }
}
