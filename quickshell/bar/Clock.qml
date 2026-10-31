import QtQuick
import qs.common

// 24 h time with seconds. Monospaced so the width doesn't jump each second.
Text {
    text:           Qt.formatTime(Time.date, "HH:mm:ss")
    color:          Theme.text
    font.family:    Theme.icons
    font.pixelSize: Sizes.px(13)
    font.bold:      true
}
