// Top bar, one per screen:
//   qs -c bar
import QtQuick
import Quickshell

ShellRoot {
    Variants {
        model: Quickshell.screens

        Bar {}
    }
}
