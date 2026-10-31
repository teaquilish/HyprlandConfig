import QtQuick
import Quickshell
import qs.common

Rectangle {
    id: root

    property string icon
    property color  tint
    property var    command

    width:        56
    height:       56
    radius:       width / 2
    color:        Qt.rgba(tint.r, tint.g, tint.b, mouse.containsMouse ? 0.32 : 0.16)
    border.width: 1
    border.color: Qt.rgba(tint.r, tint.g, tint.b, 0.45)

    Behavior on color { ColorAnimation { duration: 150 } }

    Text {
        anchors.centerIn: parent
        text:           root.icon
        color:          root.tint
        font.family:    Theme.icons
        font.pixelSize: 22
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape:  Qt.PointingHandCursor
        onClicked:    Quickshell.execDetached(root.command)
    }
}
