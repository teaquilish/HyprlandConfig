import QtQuick
import qs.common

// Notifications bell. Icon only for now: mako owns the notification server,
// so the bar has no way to count them without running makoctl.
Item {
    width:  Sizes.px(16)
    height: Sizes.px(16)

    Text {
        anchors.centerIn: parent
        // md-bell_outline
        text:           "\u{f009c}"
        color:          Theme.subtext
        font.family:    Theme.icons
        font.pixelSize: Sizes.px(16)
    }

    // TODO: click should toggle mako like SUPER + N (`makoctl mode -t show`).
    // That needs a command run from the bar, not decided yet.
}
