import QtQuick
import qs.common

// Short date like "Sat 31 Oct", always in English
Text {
    text:           Time.date.toLocaleDateString(Qt.locale("en_US"), "ddd d MMM")
    color:          Theme.subtext
    font.family:    Theme.font
    font.pixelSize: Sizes.px(12)
}
