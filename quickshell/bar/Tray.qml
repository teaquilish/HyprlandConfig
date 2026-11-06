import QtQuick
import Quickshell.Services.SystemTray
import qs.common

// System tray icons, hidden when no app has one
Row {
    spacing: Sizes.px(8)
    visible: repeater.count > 0

    Repeater {
        id: repeater
        model: SystemTray.items

        TrayItem {
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
