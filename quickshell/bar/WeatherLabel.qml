import QtQuick
import qs.common

// Weather icon and temperature after the date. Hidden until the first reading.
Row {
    spacing: Sizes.px(4)
    visible: Weather.ready

    // One decimal, U+2212 for negatives, never a minus on zero
    function formatTemp(t) {
        var tenths = Math.round(t * 10);
        var sign   = tenths < 0 ? "\u2212" : "";
        return sign + (Math.abs(tenths) / 10).toFixed(1) + "°";
    }

    Text {
        anchors.verticalCenter: parent.verticalCenter
        text:           Weather.glyph
        color:          Theme.accent
        font.family:    Theme.icons
        font.pixelSize: Sizes.px(15)
    }

    Text {
        anchors.verticalCenter: parent.verticalCenter
        text:           formatTemp(Weather.temperature)
        color:          Theme.subtext
        font.family:    Theme.font
        font.pixelSize: Sizes.px(12)
    }
}
