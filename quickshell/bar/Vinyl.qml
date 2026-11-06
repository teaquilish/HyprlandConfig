import QtQuick
import QtQuick.Shapes
import qs.common

// Small record that turns while `spinning`. Stops where it is when paused,
// nothing runs while it is hidden.
Item {
    id: root

    property bool spinning: false

    width:  Sizes.evenPx(18)
    height: Sizes.evenPx(18)

    // Drawn on an 18 px grid, then stretched to the real size
    Item {
        id: disc

        width:  18
        height: 18

        transform: [
            Rotation {
                id:       turn
                origin.x: 9
                origin.y: 9
            },
            Scale {
                xScale: root.width / 18
                yScale: root.height / 18
            }
        ]

        Rectangle {
            anchors.fill: parent
            radius:       width / 2
            color:        Qt.darker(Theme.background, 1.6)
            border.width: 1
            border.color: Theme.surface
        }

        // Grooves
        Rectangle {
            anchors.centerIn: parent
            width:            13
            height:           13
            radius:           width / 2
            color:            "transparent"
            border.width:     0.5
            border.color:     Qt.rgba(Theme.muted.r, Theme.muted.g, Theme.muted.b, 0.5)
        }

        // Light glint on the grooves, the only thing that shows it turning
        Shape {
            anchors.fill:          parent
            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                fillColor:   "transparent"
                strokeColor: Qt.rgba(Theme.subtext.r, Theme.subtext.g, Theme.subtext.b, 0.7)
                strokeWidth: 1
                capStyle:    ShapePath.RoundCap

                PathAngleArc {
                    centerX:    9
                    centerY:    9
                    radiusX:    5
                    radiusY:    5
                    startAngle: -150
                    sweepAngle: 60
                }
            }
        }

        // Label
        Rectangle {
            anchors.centerIn: parent
            width:            7
            height:           7
            radius:           width / 2
            color:            Theme.muted
        }

        // Centre hole
        Rectangle {
            anchors.centerIn: parent
            width:            2
            height:           2
            radius:           width / 2
            color:            Theme.background
        }
    }

    // Paused rather than stopped, so it picks up at the same angle. Stops
    // (and drops the angle) only when hidden.
    NumberAnimation {
        target:   turn
        property: "angle"
        from:     0
        to:       360
        duration: 4000
        loops:    Animation.Infinite
        running:  root.visible
        paused:   running && !root.spinning
    }
}
