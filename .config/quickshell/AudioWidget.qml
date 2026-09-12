import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Item {
    id: root

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    readonly property var sink:
        Pipewire.defaultAudioSink

    PwObjectTracker {
        objects:
            root.sink
            ? [root.sink]
            : []
    }

    function volumePercent() {
        if (
            !root.sink ||
            !root.sink.audio
        )
            return 0

        return Math.round(
            root.sink.audio.volume * 100
        )
    }

    function volumeIcon() {
        if (
            !root.sink ||
            !root.sink.audio ||
            root.sink.audio.muted
        )
            return ""

        var volume =
            root.sink.audio.volume * 100

        if (volume < 50)
            return ""

        if (volume <= 100)
            return ""

        return "󰕾"
    }

    function changeVolume(delta) {
        if (
            !root.sink ||
            !root.sink.audio
        )
            return

        var current =
            root.sink.audio.volume * 100

        var next =
            Math.round(
                (current + delta) / 5
            ) * 5

        next =
            Math.max(
                0,
                Math.min(100, next)
            )

        root.sink.audio.volume =
            next / 100
    }

    Row {
        id: content

        spacing: 2

        BarTextStyle {
            text: root.volumeIcon()
            textColor: "#ffffff"
        }

        BarNumberStyle {
            text: root.volumePercent()
            textColor: "#ffffff"
        }

        BarTextStyle {
            text: "%"
            textColor: "#ffffff"
        }
    }

    MouseArea {
        anchors.fill: parent

        acceptedButtons:
            Qt.LeftButton |
            Qt.RightButton |
            Qt.XButton1 |
            Qt.XButton2

        cursorShape: Qt.PointingHandCursor

        onClicked: function(mouse) {
            if (mouse.button === Qt.LeftButton) {
                audioMenu.toggle()
                return
            }

            if (mouse.button === Qt.RightButton) {
                Quickshell.execDetached([
                    "sh",
                    "-c",
                    "GTK_THEME=Adwaita:dark pavucontrol"
                ])
                return
            }

            if (mouse.button === Qt.XButton1) {
                Quickshell.execDetached([
                    "playerctl",
                    "previous"
                ])
                return
            }

            if (mouse.button === Qt.XButton2) {
                Quickshell.execDetached([
                    "playerctl",
                    "next"
                ])
                return
            }
        }

        onWheel: function(wheel) {
            if (wheel.angleDelta.y > 0)
                root.changeVolume(5)
            else if (wheel.angleDelta.y < 0)
                root.changeVolume(-5)
        }
    }

    AudioMenu {
        id: audioMenu
    }
}
