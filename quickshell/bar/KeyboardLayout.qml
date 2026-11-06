import QtQuick
import Quickshell.Hyprland
import Quickshell.Io
import qs.common

// Keyboard layout as two letters, "EN" or "RU". Asks Hyprland once at start,
// then follows its `activelayout` events.
Rectangle {
    id: root

    // Hyprland's keymap name, e.g. "English (US)" or "Russian"
    property string keymap: ""
    // Last keymap seen while reading the device list
    property string listedKeymap: ""

    width:  Sizes.px(26)
    radius: Sizes.px(6)
    color:  Theme.track

    function shortName(name) {
        if (name === "English (US)")
            return "EN";
        if (name === "Russian")
            return "RU";
        return name.slice(0, 2).toUpperCase();
    }

    Text {
        anchors.centerIn: parent
        text:           root.shortName(root.keymap)
        color:          Theme.text
        font.family:    Theme.font
        font.pixelSize: Sizes.px(12)
        font.bold:      true
    }

    // One `j/devices` request. The keyboard marked main is the one in use;
    // its "active_keymap" line comes before its "main" line. Hangs up on the
    // closing brace, before Hyprland does, so Socket doesn't log an error.
    Socket {
        id: request
        path:      Hyprland.requestSocketPath
        connected: true

        onConnectionStateChanged: {
            if (connected) {
                write("j/devices");
                flush();
            }
        }

        parser: SplitParser {
            onRead: line => {
                const keymap = line.match(/"active_keymap":\s*"(.*)"/);
                if (keymap)
                    root.listedKeymap = keymap[1];
                else if (/"main":\s*true/.test(line) && root.keymap === "")
                    root.keymap = root.listedKeymap;
                else if (line === "}")
                    request.connected = false;
            }
        }
    }

    // Data is "KEYBOARD,LAYOUT"
    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (event.name === "activelayout")
                root.keymap = event.parse(2)[1];
        }
    }
}
