import QtQuick
import QtQuick.Shapes
import Quickshell.Services.Pipewire
import qs.common

// Default output volume: a speaker in a ring that fills with the volume,
// and the percent after it. Scroll changes it by 5 %, click mutes.
// Hidden until there's a default sink.
Item {
    id: root

    readonly property PwNode sink:   Pipewire.defaultAudioSink
    readonly property bool   ready:  sink !== null && sink.ready && sink.audio !== null
    readonly property real   volume: ready ? sink.audio.volume : 0
    readonly property bool   muted:  ready && sink.audio.muted

    // Ring fill, 0 to 1, eased on change
    property real shown: Math.max(0, Math.min(1, volume))

    implicitWidth:  row.implicitWidth
    implicitHeight: row.implicitHeight
    visible:        ready

    Behavior on shown {
        NumberAnimation {
            duration:    120
            easing.type: Easing.OutCubic
        }
    }

    // Volume and mute are only valid on a bound node
    PwObjectTracker {
        objects: [root.sink]
    }

    function glyph() {
        if (muted)
            return "\u{f0581}"; // md-volume_off
        if (volume < 0.34)
            return "\u{f057f}"; // md-volume_low
        if (volume < 0.67)
            return "\u{f0580}"; // md-volume_medium
        return "\u{f057e}"; // md-volume_high
    }

    Row {
        id: row
        anchors.verticalCenter: parent.verticalCenter
        spacing: Sizes.px(4)

        Item {
            id: ring

            readonly property int  size:   Sizes.evenPx(20)
            readonly property int  stroke: Sizes.px(2)
            readonly property real radius: (size - stroke) / 2

            anchors.verticalCenter: parent.verticalCenter
            width:  size
            height: size

            Shape {
                anchors.fill:          parent
                preferredRendererType: Shape.CurveRenderer

                ShapePath {
                    strokeColor: Theme.track
                    strokeWidth: ring.stroke
                    fillColor:   "transparent"

                    PathAngleArc {
                        centerX:    ring.size / 2
                        centerY:    ring.size / 2
                        radiusX:    ring.radius
                        radiusY:    ring.radius
                        startAngle: 0
                        sweepAngle: 360
                    }
                }

                ShapePath {
                    strokeColor: root.muted ? Theme.muted : Theme.accent
                    strokeWidth: ring.stroke
                    fillColor:   "transparent"
                    capStyle:    ShapePath.RoundCap

                    PathAngleArc {
                        centerX:    ring.size / 2
                        centerY:    ring.size / 2
                        radiusX:    ring.radius
                        radiusY:    ring.radius
                        startAngle: -90
                        sweepAngle: 360 * root.shown
                    }
                }
            }

            Text {
                anchors.centerIn: parent
                text:           root.glyph()
                color:          root.muted ? Theme.muted : Theme.text
                font.family:    Theme.icons
                font.pixelSize: Sizes.px(11)
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text:           Math.round(root.volume * 100) + "%"
            color:          root.muted ? Theme.muted : Theme.subtext
            font.family:    Theme.font
            font.pixelSize: Sizes.px(12)
        }
    }

    MouseArea {
        anchors.fill:    parent
        acceptedButtons: Qt.LeftButton

        onClicked: {
            if (root.ready)
                root.sink.audio.muted = !root.sink.audio.muted;
        }

        onWheel: wheel => {
            if (!root.ready || wheel.angleDelta.y === 0)
                return;
            const step = wheel.angleDelta.y > 0 ? 0.05 : -0.05;
            root.sink.audio.volume = Math.max(0, Math.min(1, root.sink.audio.volume + step));
        }
    }
}
