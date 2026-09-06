import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    implicitWidth: mpdText.implicitWidth
    implicitHeight: mpdText.implicitHeight

    property string state: "disconnected"

    function updateStatus() {
        statusProcess.running = false
        statusProcess.running = true
    }

    function control(action) {
        switch (action) {
        case "toggle":
            toggleProcess.running = false
            toggleProcess.running = true
            break

        case "next":
            nextProcess.running = false
            nextProcess.running = true
            break

        case "previous":
            previousProcess.running = false
            previousProcess.running = true
            break

        case "forward":
            forwardProcess.running = false
            forwardProcess.running = true
            break

        case "backward":
            backwardProcess.running = false
            backwardProcess.running = true
            break
        }
    }

    BarIconStyle {
        id: mpdText

        anchors.centerIn: parent

        text: {
            switch (root.state) {
            case "playing":
                return ""

            case "paused":
                return ""

            case "stopped":
                return ""

            default:
                return ""
            }
        }
    }

    MouseArea {
        anchors.fill: parent

        acceptedButtons: Qt.AllButtons
        cursorShape: Qt.PointingHandCursor

        onClicked: function(mouse) {
            switch (mouse.button) {
            case Qt.LeftButton:
                root.control("toggle")
                break

            case Qt.RightButton:
                root.control("next")
                break

            case Qt.MiddleButton:
                root.control("previous")
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

    Process {
        id: statusProcess

        command: [
            "mpc",
            "status"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                const output = text

                if (!output || output.trim() === "") {
                    root.state = "disconnected"
                    return
                }

                if (
                    output.includes("[playing]")
                    || output.includes("playing")
                ) {
                    root.state = "playing"
                } else if (
                    output.includes("[paused]")
                    || output.includes("paused")
                ) {
                    root.state = "paused"
                } else if (
                    output.includes("[stopped]")
                    || output.includes("stopped")
                ) {
                    root.state = "stopped"
                } else {
                    root.state = "disconnected"
                }
            }
        }

        onExited: function(exitCode, exitStatus) {
            if (exitCode !== 0)
                root.state = "disconnected"
        }
    }

    Process {
        id: toggleProcess

        command: [
            "mpc",
            "toggle"
        ]

        onExited: {
            root.updateStatus()
        }
    }

    Process {
        id: nextProcess

        command: [
            "mpc",
            "next"
        ]

        onExited: {
            root.updateStatus()
        }
    }

    Process {
        id: previousProcess

        command: [
            "mpc",
            "prev"
        ]

        onExited: {
            root.updateStatus()
        }
    }

    Process {
        id: forwardProcess

        command: [
            "mpc",
            "seek",
            "+5"
        ]

        onExited: {
            root.updateStatus()
        }
    }

    Process {
        id: backwardProcess

        command: [
            "mpc",
            "seek",
            "-5"
        ]

        onExited: {
            root.updateStatus()
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            root.updateStatus()
        }
    }

    Component.onCompleted: {
        root.updateStatus()
    }
}
