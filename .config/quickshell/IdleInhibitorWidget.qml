// IdleInhibitorWidget.qml
import Quickshell.Io
import QtQuick

Item {
    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight

    BarTextStyle {
        id: icon
        text: "󰍹"
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            toggleProcess.running = true
        }
    }

    Process {
        id: toggleProcess

        command: [
            "sh",
            "-c",
            "if pgrep -x hypridle >/dev/null; then killall hypridle && notify-send 'stop hypridle'; else notify-send 'start hypridle' && hypridle >/dev/null 2>&1 & fi"
        ]
    }
}
