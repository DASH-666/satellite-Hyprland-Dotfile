// IdleInhibitorWidget.qml

import Quickshell.Io
import QtQuick

Item {
    id: root

    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight

    property bool idleActive: false

    BarTextStyle {
        id: icon

        text: root.idleActive
            ? "󰶐"
            : "󰍹"
    }

    Timer {
        id: statusTimer

        interval: 500
        running: true
        repeat: true

        onTriggered: {
            checkProcess.running = true
        }
    }

    Process {
        id: checkProcess

        command: [
            "pgrep",
            "-x",
            "hypridle"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                root.idleActive = text.trim() !== ""
            }
        }
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

        onRunningChanged: {
            if (!running)
                checkProcess.running = true
        }
    }
}
