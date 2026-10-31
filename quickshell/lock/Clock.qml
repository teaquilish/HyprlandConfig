import QtQuick
import qs.common

// Round clock with hour, minute and second hands
Item {
    id: root

    property real size: 480
    property date now:  new Date()

    readonly property real seconds: now.getSeconds()
    readonly property real minutes: now.getMinutes() + seconds / 60
    readonly property real hours:   now.getHours() % 12 + minutes / 60

    width:  size
    height: size

    Timer {
        interval:         1000
        running:          true
        repeat:           true
        triggeredOnStart: true
        onTriggered:      root.now = new Date()
    }

    Rectangle {
        anchors.fill: parent
        radius:       width / 2
        color:        Theme.glass
        border.width: 2
        border.color: Theme.glassBorder
    }

    // 60 marks around the edge, every 5th one longer
    Repeater {
        model: 60

        Item {
            required property int index

            readonly property bool hourMark: index % 5 === 0

            anchors.fill: parent
            rotation:     index * 6

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                y:      root.size * 0.04
                width:  parent.hourMark ? 4 : 2
                height: parent.hourMark ? root.size * 0.055 : root.size * 0.025
                radius: width / 2
                color:  parent.hourMark ? Theme.text : Qt.rgba(1, 1, 1, 0.3)
            }
        }
    }

    component Hand: Rectangle {
        property real length
        property real angle

        x:      (parent.width - width) / 2
        y:      parent.height / 2 - length
        height: length
        radius: width / 2

        // Pivot on the center of the clock
        transformOrigin: Item.Bottom
        rotation:        angle

        Behavior on rotation {
            RotationAnimation {
                duration:    500
                direction:   RotationAnimation.Clockwise
                easing.type: Easing.OutBack
            }
        }
    }

    Hand {
        width:  9
        length: root.size * 0.24
        angle:  root.hours * 30
        color:  Theme.text
    }

    Hand {
        width:  6
        length: root.size * 0.36
        angle:  root.minutes * 6
        color:  Theme.text
    }

    Hand {
        width:  2
        length: root.size * 0.41
        angle:  root.seconds * 6
        color:  Theme.accent
    }

    Rectangle {
        anchors.centerIn: parent
        width:        16
        height:       16
        radius:       8
        color:        Theme.accent
        border.width: 3
        border.color: Theme.background
    }
}
