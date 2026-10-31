import QtQuick
import qs.common

Rectangle {
    id: root

    required property var context

    width:        440
    height:       64
    radius:       18
    color:        Theme.glass
    border.width: 2
    border.color: root.context.error !== "" ? Theme.red
                : root.context.checking     ? Theme.accentAlt
                : input.activeFocus         ? Theme.accent
                :                             Theme.glassBorder

    Behavior on border.color { ColorAnimation { duration: 200 } }

    // Shakes the box after a wrong password
    transform: Translate { id: offset }

    SequentialAnimation {
        id: shake
        NumberAnimation { target: offset; property: "x"; to: -14; duration: 50 }
        NumberAnimation { target: offset; property: "x"; to: 12;  duration: 70 }
        NumberAnimation { target: offset; property: "x"; to: -8;  duration: 70 }
        NumberAnimation { target: offset; property: "x"; to: 0;   duration: 90 }
    }

    Connections {
        target: root.context

        function onFailed() {
            shake.restart();
        }

        // Keeps the box in sync on every screen
        function onPasswordChanged() {
            if (input.text !== root.context.password)
                input.text = root.context.password;
        }
    }

    Text {
        anchors.left:           parent.left
        anchors.leftMargin:     24
        anchors.verticalCenter: parent.verticalCenter
        text:           "󰌾"
        color:          Theme.subtext
        font.family:    Theme.icons
        font.pixelSize: 20
    }

    Text {
        anchors.centerIn: parent
        visible:        input.text === ""
        text:           "Password"
        color:          Theme.subtext
        font.family:    Theme.font
        font.pixelSize: 20
    }

    TextInput {
        id: input
        anchors.fill:        parent
        anchors.leftMargin:  64
        anchors.rightMargin: 64
        verticalAlignment:   TextInput.AlignVCenter
        horizontalAlignment: TextInput.AlignHCenter
        echoMode:            TextInput.Password
        passwordCharacter:   "●"
        passwordMaskDelay:   0
        inputMethodHints:    Qt.ImhSensitiveData
        readOnly:            root.context.checking
        clip:                true
        focus:               true
        color:               Theme.text
        font.family:         Theme.font
        font.pixelSize:      18
        font.letterSpacing:  4

        Component.onCompleted: forceActiveFocus()

        onTextChanged: {
            root.context.password = text;
            if (text !== "")
                root.context.error = "";
        }
        onAccepted: root.context.tryUnlock()
        Keys.onEscapePressed: text = ""
    }

    // Keyboard layout: "English (US)" -> "EN"
    Text {
        anchors.top:              parent.bottom
        anchors.topMargin:        18
        anchors.horizontalCenter: parent.horizontalCenter
        text:           root.context.layout.slice(0, 2).toUpperCase()
        color:          Theme.subtext
        font.family:    Theme.font
        font.pixelSize: 15
        font.weight:    Font.Medium
    }

    Text {
        anchors.bottom:           parent.top
        anchors.bottomMargin:     18
        anchors.horizontalCenter: parent.horizontalCenter
        text:           root.context.error
        opacity:        text !== "" ? 1 : 0
        color:          Theme.red
        font.family:    Theme.font
        font.pixelSize: 16

        Behavior on opacity { NumberAnimation { duration: 200 } }
    }
}
