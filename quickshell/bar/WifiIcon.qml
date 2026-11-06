import QtQuick
import Quickshell.Networking
import qs.common

// Wi-Fi state from NetworkManager: connected, on but not connected, or off.
// Hidden when there's no Wi-Fi device.
Item {
    id: root

    readonly property NetworkDevice device: Networking.devices.values.find(d => d.type === DeviceType.Wifi) ?? null
    readonly property bool enabled:   Networking.wifiEnabled && Networking.wifiHardwareEnabled
    readonly property bool connected: enabled && device !== null && device.connected

    width:   Sizes.px(16)
    height:  Sizes.px(16)
    visible: device !== null

    Text {
        anchors.centerIn: parent
        // md-wifi, md-wifi_strength_outline, md-wifi_off
        text:           root.connected ? "\u{f05a9}" : root.enabled ? "\u{f092f}" : "\u{f05aa}"
        color:          root.connected ? Theme.text : Theme.muted
        font.family:    Theme.icons
        font.pixelSize: Sizes.px(16)
    }
}
