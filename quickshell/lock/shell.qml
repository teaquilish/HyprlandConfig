// Lock screen. Locks as soon as it starts and quits after unlocking:
//   qs -p ~/.config/quickshell/lock
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Pam
import Quickshell.Wayland
import qs.common

ShellRoot {
    id: root

    // Shared by the lock surfaces on every screen
    property string password:  ""
    property string error:     ""
    property string layout:    ""
    property bool   checking:  false
    property bool   unlocking: false

    signal failed()

    function tryUnlock() {
        if (password === "" || checking)
            return;
        error = "";
        checking = true;
        if (!pam.start()) {
            checking = false;
            error = "Couldn't check the password";
        }
    }

    // Uses /etc/pam.d/login, like hyprlock does
    PamContext {
        id: pam

        onPamMessage: {
            if (responseRequired)
                respond(root.password);
            else if (messageIsError)
                root.error = message;
        }

        onCompleted: result => {
            root.checking = false;
            root.password = "";
            if (result === PamResult.Success) {
                root.unlocking = true;
            } else {
                if (root.error === "")
                    root.error = "Wrong password";
                root.failed();
            }
        }
    }

    // Let the fade-out finish, then unlock. Unlocking before quitting matters:
    // if the lock just dies, Hyprland keeps the screen locked for safety.
    Timer {
        interval: 400
        running:  root.unlocking
        onTriggered: {
            lock.locked = false;
            Qt.quit();
        }
    }

    // Keyboard layout: read it once, then follow Hyprland's layout events
    Process {
        running: true
        command: ["hyprctl", "devices", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                const main = JSON.parse(text).keyboards.find(k => k.main);
                if (main)
                    root.layout = main.active_keymap;
            }
        }
    }

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (event.name === "activelayout")
                root.layout = event.data.substring(event.data.indexOf(",") + 1);
        }
    }

    WlSessionLock {
        id: lock
        locked: true

        WlSessionLockSurface {
            color: Theme.background

            LockSurface {
                anchors.fill: parent
                context:      root
            }
        }
    }
}
