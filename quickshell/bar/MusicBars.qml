import QtQuick
import qs.common

// Little equalizer for show, not driven by the audio. Each bar bounces
// between its own two heights at its own pace while `bouncing`, and drops
// to the rest height otherwise.
Item {
    id: root

    property bool bouncing: false

    // Per bar: [low, high] as a share of the full height, and ms per half bounce
    readonly property var levels:    [[0.35, 0.9], [0.55, 1.0], [0.25, 0.75], [0.45, 0.95], [0.3, 0.7]]
    readonly property var durations: [420, 330, 510, 370, 460]

    readonly property int barWidth:   Sizes.px(3)
    readonly property int barSpacing: Sizes.px(2)
    readonly property int restHeight: Sizes.px(3)

    width:  levels.length * barWidth + (levels.length - 1) * barSpacing
    height: Sizes.evenPx(14)

    Repeater {
        model: root.levels.length

        Rectangle {
            id: bar

            required property int index

            readonly property real low:  root.levels[index][0] * root.height
            readonly property real high: root.levels[index][1] * root.height
            property real level:         low

            x:      index * (root.barWidth + root.barSpacing)
            y:      root.height - height
            width:  root.barWidth
            height: root.bouncing ? Math.max(root.restHeight, level) : root.restHeight
            radius: width / 2
            // Left to right from accent to accentAlt, like the day line
            color:  Qt.rgba(Theme.accent.r + (Theme.accentAlt.r - Theme.accent.r) * index / (root.levels.length - 1),
                            Theme.accent.g + (Theme.accentAlt.g - Theme.accent.g) * index / (root.levels.length - 1),
                            Theme.accent.b + (Theme.accentAlt.b - Theme.accent.b) * index / (root.levels.length - 1),
                            1)

            SequentialAnimation {
                running: root.visible && root.bouncing
                loops:   Animation.Infinite

                NumberAnimation {
                    target:      bar
                    property:    "level"
                    from:        bar.low
                    to:          bar.high
                    duration:    root.durations[bar.index]
                    easing.type: Easing.InOutSine
                }

                NumberAnimation {
                    target:      bar
                    property:    "level"
                    from:        bar.high
                    to:          bar.low
                    duration:    root.durations[bar.index]
                    easing.type: Easing.InOutSine
                }
            }
        }
    }
}
