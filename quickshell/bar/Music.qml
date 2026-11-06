pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Mpris

// The MPRIS player the bar shows, shared by every screen: the first one
// playing, else the first one paused. Players without a title don't count.
Singleton {
    id: root

    readonly property MprisPlayer player: pick(Mpris.players.values)

    readonly property bool   shown:    player !== null
    readonly property bool   playing:  shown && player.playbackState === MprisPlaybackState.Playing
    readonly property string title:    shown ? player.trackTitle.trim() : ""
    readonly property string artist:   shown ? player.trackArtist.trim() : ""
    // Part of the track played, 0 to 1. 0 when the length is unknown.
    readonly property real   progress: shown && player.lengthSupported && player.length > 0
                                       ? Math.max(0, Math.min(1, player.position / player.length))
                                       : 0

    function pick(players) {
        var paused = null;
        for (var i = 0; i < players.length; i++) {
            var p = players[i];
            if (p.trackTitle.trim() === "")
                continue;
            if (p.playbackState === MprisPlaybackState.Playing)
                return p;
            if (!paused && p.playbackState === MprisPlaybackState.Paused)
                paused = p;
        }
        return paused;
    }

    // Quickshell doesn't update position by itself while a track plays, it
    // only computes it when read. Nudging positionChanged once a second is
    // the polling its docs suggest; it runs only while something plays.
    Timer {
        interval:         1000
        repeat:           true
        triggeredOnStart: true
        running:     root.playing && root.player.positionSupported
        onTriggered: root.player.positionChanged()
    }
}
