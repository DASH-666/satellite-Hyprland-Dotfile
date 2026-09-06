import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick

Item {
    id: root

    readonly property string keyboardName: "at-translated-set-2-keyboard"

    property string currentLayout: "EN"

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    function updateLayout(layout) {
        var value = String(layout).toLowerCase()

        if (
            value.includes("persian")
            || value.includes("farsi")
            || value.includes("iran")
            || value === "fa"
        ) {
            root.currentLayout = "fa"
            return
        }

        if (
            value.includes("english")
            || value.includes("us")
            || value === "en"
        ) {
            root.currentLayout = "en"
            return
        }

        root.currentLayout = "EN"
    }

    function switchLayout() {
        switchLayoutProcess.running = false
        switchLayoutProcess.running = true
    }

    Row {
        id: content

        BarTextStyle {
            text: root.currentLayout
        }
    }

    MouseArea {
        anchors.fill: content

        acceptedButtons: Qt.AllButtons
        cursorShape: Qt.PointingHandCursor

        onClicked: function(mouse) {
            switch (mouse.button) {
            case Qt.LeftButton:
                root.switchLayout()
                break

            case Qt.RightButton:
                root.switchLayout()
                break

            case Qt.MiddleButton:
                root.switchLayout()
                break

            case Qt.XButton1:
                root.switchLayout()
                break

            case Qt.XButton2:
                root.switchLayout()
                break
            }
        }

        onWheel: function(wheel) {
            if (wheel.angleDelta.y > 0) {
                root.switchLayout()
            } else if (wheel.angleDelta.y < 0) {
                root.switchLayout()
            }
        }
    }

    Process {
        id: switchLayoutProcess

        command: [
            "hyprctl",
            "switchxkblayout",
            root.keyboardName,
            "next"
        ]
    }

    Process {
        id: initialLayoutProcess

        command: [
            "hyprctl",
            "devices",
            "-j"
        ]

        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var data = JSON.parse(text)

                    if (!data.keyboards)
                        return

                    for (var i = 0; i < data.keyboards.length; i++) {
                        var keyboard = data.keyboards[i]

                        if (keyboard.name !== root.keyboardName)
                            continue

                        root.updateLayout(
                            keyboard.active_keymap || ""
                        )

                        break
                    }
                } catch (error) {
                    console.warn(
                        "LanguageWidget: failed to parse keyboard state:",
                        error
                    )
                }
            }
        }
    }

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (event.name !== "activelayout")
                return

            var data = event.parse(2)

            if (data.length < 2)
                return

            if (data[0] !== root.keyboardName)
                return

            root.updateLayout(data[1])
        }
    }
}
