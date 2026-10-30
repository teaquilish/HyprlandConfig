import QtQuick
import QtQuick.Effects

Item {
    id: root

    required property var context

    property bool shown: false

    Component.onCompleted: shown = true

    // Blurred wallpaper. The image is a bit bigger than the screen,
    // so the blur doesn't fade out at the edges. It's loaded at a quarter
    // of the size: after this much blur nobody can tell, and it saves RAM.
    Image {
        id: wallpaper
        anchors.fill:    parent
        anchors.margins: -64
        source:          "file://" + Theme.wallpaper
        sourceSize:      Qt.size(width / 4, height / 4)
        fillMode:        Image.PreserveAspectCrop
        visible:         false
    }

    MultiEffect {
        anchors.fill: wallpaper
        source:       wallpaper
        blurEnabled:  true
        blur:         1.0
        blurMax:      64
        brightness:   -0.12
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, 0.05) }
            GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.35) }
        }
    }

    // Everything on top fades in when locking and out when unlocking
    Item {
        anchors.fill: parent
        opacity:      root.shown && !root.context.unlocking ? 1 : 0
        scale:        root.shown && !root.context.unlocking ? 1 : 0.96

        Behavior on opacity { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }
        Behavior on scale   { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }

        Clock {
            id: clock
            x:    parent.width * 0.27 - width / 2
            anchors.verticalCenter: parent.verticalCenter
            size: Math.min(root.height * 0.36, 520)
        }

        Rectangle {
            anchors.bottom:           clock.top
            anchors.bottomMargin:     36
            anchors.horizontalCenter: clock.horizontalCenter
            width:        time.implicitWidth + 64
            height:       time.implicitHeight + 20
            radius:       18
            color:        Theme.glass
            border.width: 2
            border.color: Theme.glassBorder

            Text {
                id: time
                anchors.centerIn: parent
                text:               Qt.formatTime(clock.now, "HH:mm")
                color:              Theme.text
                font.family:        Theme.font
                font.pixelSize:     44
                font.weight:        Font.Light
                font.letterSpacing: 2
            }
        }

        Text {
            anchors.top:              clock.bottom
            anchors.topMargin:        36
            anchors.horizontalCenter: clock.horizontalCenter
            text:           clock.now.toLocaleDateString(Qt.locale("en_US"), "dddd, d MMMM")
            color:          Theme.text
            font.family:    Theme.font
            font.pixelSize: 30
            font.weight:    Font.Light
        }

        // Centered on the clock's middle, so both line up
        PasswordBox {
            x:       parent.width * 0.63 - width / 2
            anchors.verticalCenter: clock.verticalCenter
            context: root.context
        }

        Row {
            anchors.right:   parent.right
            anchors.bottom:  parent.bottom
            anchors.margins: 48
            spacing:         16

            PowerButton {
                icon:    "󰜉"
                tint:    Theme.yellow
                command: ["systemctl", "reboot"]
            }

            PowerButton {
                icon:    "󰐥"
                tint:    Theme.red
                command: ["systemctl", "poweroff"]
            }
        }
    }
}
