import QtQuick
import Quickshell.Bluetooth
import qs.common

// Bluetooth state: on with a device connected, on, or off. Hidden when
// there's no adapter.
Item {
    id: root

    readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
    readonly property bool enabled:   adapter !== null && adapter.enabled
    readonly property bool connected: enabled && adapter.devices.values.some(d => d.connected)

    width:   Sizes.px(16)
    height:  Sizes.px(16)
    visible: adapter !== null

    Text {
        anchors.centerIn: parent
        // md-bluetooth_connect, md-bluetooth, md-bluetooth_off
        text:           root.connected ? "\u{f00b1}" : root.enabled ? "\u{f00af}" : "\u{f00b2}"
        color:          root.connected ? Theme.text : root.enabled ? Theme.subtext : Theme.muted
        font.family:    Theme.icons
        font.pixelSize: Sizes.px(16)
    }
}
