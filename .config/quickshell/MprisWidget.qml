import Quickshell
import Quickshell.Services.Mpris
import QtQuick

Item {
    id: root

    property MprisPlayer player: null

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    function isRealPlayer(p) {
        return p
            && p.dbusName
            && !p.dbusName.startsWith(
                "org.mpris.MediaPlayer2.playerctld"
            )
    }

    function playerName() {
        if (!player || !player.dbusName)
            return ""

        return player.dbusName
            .replace(/^org\.mpris\.MediaPlayer2\./, "")
            .split(".")[0]
    }

    function playerIcon() {
        switch (playerName().toLowerCase()) {
        case "chromium":
        case "chrome":
            return ""
        case "firefox":
            return ""
        case "telegramdesktop":
            return ""
        case "mpv":
            return "󰿎"
        case "mpd":
            return ""
        default:
            return ""
        }
    }

    function statusIcon() {
        return player
            ? (player.isPlaying ? "" : "")
            : ""
    }

    function control(action) {
        if (!player)
            return

        switch (action) {
        case "toggle":
            if (player.canTogglePlaying)
                player.togglePlaying()
            break

        case "next":
            if (player.canGoNext)
                player.next()
            break

        case "previous":
            if (player.canGoPrevious)
                player.previous()
            break

        case "stop":
            if (player.canControl)
                player.stop()
            break

        case "forward":
            if (player.canSeek)
                player.seek(5)
            break

        case "backward":
            if (player.canSeek)
                player.seek(-5)
            break
        }
    }

    function findPlayer() {
        var players = Mpris.players.values

        for (var i = 0; i < players.length; i++) {
            if (isRealPlayer(players[i]) && players[i].isPlaying) {
                player = players[i]
                return
            }
        }

        for (var j = 0; j < players.length; j++) {
            if (isRealPlayer(players[j])) {
                player = players[j]
                return
            }
        }

        player = null
    }

    Row {
        id: content
        spacing: 4

        BarIconStyle {
            text: root.player
                ? root.playerIcon()
                : ""
        }

        BarTextStyle {
            text: root.player
                ? root.playerName()
                : ""
        }

        BarIconStyle {
            text: root.statusIcon()
        }
    }

    MouseArea {
        anchors.fill: content

        acceptedButtons: Qt.AllButtons
        cursorShape: Qt.PointingHandCursor

        onClicked: function(mouse) {
            switch (mouse.button) {
            case Qt.LeftButton:
                root.control("toggle")
                break

            case Qt.RightButton:
                root.control("stop")
                break

            case Qt.MiddleButton:
                root.control("next")
                break

            case Qt.XButton1:
                root.control("previous")
                break

            case Qt.XButton2:
                root.control("next")
                break
            }
        }

        onWheel: function(wheel) {
            if (wheel.angleDelta.y > 0)
                root.control("forward")
            else if (wheel.angleDelta.y < 0)
                root.control("backward")
        }
    }

    Instantiator {
        model: Mpris.players

        delegate: Connections {
            required property MprisPlayer modelData

            target: modelData

            Component.onCompleted: {
                if (!root.isRealPlayer(modelData))
                    return

                if (
                    root.player === null
                    || modelData.isPlaying
                ) {
                    root.player = modelData
                }
            }

            Component.onDestruction: {
                if (root.player === modelData)
                    root.findPlayer()
            }

            function onPlaybackStateChanged() {
                if (
                    root.isRealPlayer(modelData)
                    && modelData.isPlaying
                ) {
                    root.player = modelData
                }
            }
        }
    }

    Component.onCompleted: {
        root.findPlayer()
    }
}
