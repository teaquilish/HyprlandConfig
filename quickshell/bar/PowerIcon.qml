import QtQuick
import qs.common

// Power button. Does nothing yet, its menu comes later.
Item {
    width:  Sizes.px(16)
    height: Sizes.px(16)

    Text {
        anchors.centerIn: parent
        // md-power
        text:           "\u{f0425}"
        color:          Theme.subtext
        font.family:    Theme.icons
        font.pixelSize: Sizes.px(16)
    }
}
