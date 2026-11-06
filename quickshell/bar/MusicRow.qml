import QtQuick
import qs.common

// What plays now: turning record, "title · artist" and the bouncing bars.
// Record and bars move only while the track plays.
Row {
    id: root

    // Last track shown, kept while the row fades out after the player goes
    property string title:  ""
    property string artist: ""

    spacing: Sizes.px(8)

    function escapeHtml(s) {
        return s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
    }

    // Music.player is already null when title and artist go empty, so the
    // last track stays put
    function sync() {
        if (!Music.player)
            return;
        title  = Music.title;
        artist = Music.artist;
    }

    Component.onCompleted: sync()

    Connections {
        target: Music

        function onTitleChanged() {
            root.sync();
        }

        function onArtistChanged() {
            root.sync();
        }
    }

    Vinyl {
        anchors.verticalCenter: parent.verticalCenter
        spinning: Music.playing
    }

    // Artist in the dimmer color after the title
    Text {
        anchors.verticalCenter: parent.verticalCenter
        width:          Math.min(implicitWidth, Sizes.px(160))
        elide:          Text.ElideRight
        textFormat:     Text.StyledText
        text:           root.escapeHtml(root.title)
                        + (root.artist !== ""
                           ? "<font color=\"" + Theme.subtext + "\"> · " + root.escapeHtml(root.artist) + "</font>"
                           : "")
        color:          Theme.text
        font.family:    Theme.font
        font.pixelSize: Sizes.px(12)
    }

    MusicBars {
        anchors.verticalCenter: parent.verticalCenter
        bouncing: Music.playing
    }
}
