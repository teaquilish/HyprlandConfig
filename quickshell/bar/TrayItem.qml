import QtQuick
import Quickshell.Services.SystemTray
import qs.common

// One tray icon. Left click opens the app, right click its secondary action
// (the app's own menu comes later).
Item {
    id: root

    required property SystemTrayItem modelData

    width:  Sizes.px(16)
    height: Sizes.px(16)

    Image {
        anchors.fill: parent
        source:       root.modelData.icon
        sourceSize:   Qt.size(width, height)
        fillMode:     Image.PreserveAspectFit
        smooth:       true
        mipmap:       true
    }

    MouseArea {
        anchors.fill:    parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton)
                root.modelData.activate();
            else
                root.modelData.secondaryActivate();
        }
    }
}
